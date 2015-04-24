class DefenceRequest < ActiveRecord::Base
  DSCC_SUFFIX = 'Z'

  include ActiveModel::Transitions

  attr_accessor :cco, :solicitor

  after_update :notify_interview_start_change, if: :interview_start_time_changed?

  scope :accepted_or_aborted, -> { where(state: ["accepted", "aborted"]) }
  scope :not_aborted, -> { where.not(state: "aborted") }
  scope :not_draft, -> { where.not(state: "draft") }
  scope :ordered_by_created_at, -> { order(created_at: :asc) }

  def self.related_to_solicitor(solicitor)
    where(organisation_uid: solicitor.organisation_uids.first)
  end

  state_machine auto_scopes: true do
    state :draft # first one is initial state
    state :queued
    state :acknowledged
    state :accepted
    state :aborted
    state :finished

    event :queue do
      transitions from: [:draft], to: :queued
    end

    event :acknowledge do
      transitions from: [:queued], to: :acknowledged
    end

    event :accept, success: :send_solicitor_case_details do
      transitions from: [:acknowledged], to: :accepted, guard: :dscc_number?
    end

    event :abort do
      transitions from: [:queued, :acknowledged, :accepted], to: :aborted
    end

    event :finish do
      transitions from: [:acknowledged, :accepted], to: :finished
    end

  end

  validates :reason_aborted, presence: true, if: :aborted?

  validates :solicitor_name,
            :solicitor_firm,
            :phone_number, presence: true, if: :own_solicitor?

  validates :scheme, presence: true, if: :duty_solicitor?

  validates :detainee_name,
            :offences,
            :gender,
            :time_of_arrival,
            :custody_number, presence: true

  validates :detainee_age, numericality: true, presence: true

  validates :appropriate_adult_reason, presence: true, if: :appropriate_adult?

  validates :unfit_for_interview_reason, presence: true, unless: :fit_for_interview?

  validates :interpreter_type, presence: true, if: :interpreter_required

  validates :dscc_number, uniqueness: true, allow_nil: true

  audited

  SCHEMES = [ "No Scheme",
              "Brighton Scheme 1",
              "Brighton Scheme 2",
              "Brighton Scheme 3"]

  def resend_details
    send_solicitor_case_details
  end

  def duty_solicitor?
    solicitor_type == "duty"
  end

  def own_solicitor?
    solicitor_type == "own"
  end

  def phone_number=(new_value)
    super(format_phone_number(new_value))
  end

  # Generates a new dscc number and saves the model in one go, should not be called
  # with a dirty model, or changes will be blown lost.
  def generate_dscc_number!
    return false unless persisted? && valid?

    self.class.connection.execute dscc_number_generation_sql
    reload
  end

  private

  def dscc_number_generation_sql
    prefix = created_at.strftime('%y%m')

    <<-SQL.strip_heredoc
      BEGIN;
      LOCK TABLE defence_requests IN ACCESS EXCLUSIVE MODE;

      WITH next_dscc_number AS (SELECT cast(cast(substr(coalesce(max(dscc_number), '000000000'), 5,5) as integer) + 1 as text) as number
                                FROM defence_requests
                                WHERE dscc_number ~ '^#{prefix}')

      UPDATE defence_requests SET dscc_number = (SELECT '#{prefix}' || lpad(number, 5, '0') || '#{DSCC_SUFFIX}'
                                                 FROM next_dscc_number)
      WHERE id = #{id};

      COMMIT;
    SQL
  end

  def format_phone_number(phone_number)
    phone_number.to_s.gsub(/\D/, '') if phone_number
  end

  def notify_interview_start_change
    Mailer.notify_interview_start_change(self, solicitor).deliver_later if solicitor
  end

  def send_solicitor_case_details
    Mailer.send_solicitor_case_details(self, solicitor).deliver_later if solicitor
  end
end
