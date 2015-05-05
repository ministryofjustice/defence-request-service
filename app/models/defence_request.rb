class DefenceRequest < ActiveRecord::Base
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
    state :completed

    event :queue do
      transitions from: [:draft], to: :queued
    end

    event :acknowledge do
      transitions from: [:queued], to: :acknowledged
    end

    event :accept, success: :send_solicitor_case_details do
      transitions from: [:acknowledged], to: :accepted, guard: [:dscc_number?, :solicitor_name?, :solicitor_firm?, :phone_number?]
    end

    event :abort do
      transitions from: [:queued, :acknowledged, :accepted], to: :aborted
    end

    event :complete do
      transitions from: [:acknowledged, :accepted], to: :completed
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

  def generate_dscc_number!
    if result = DsccNumberGenerator.new(self).generate!

      # Use raw_write_attribute here so the attributes are not marked as dirty
      # as these values are the same as in the database
      raw_write_attribute :dscc_number, result[:dscc_number]
      raw_write_attribute :updated_at, Time.zone.parse(result[:updated_at])
    else
      false
    end
  end

  private

  def format_phone_number(phone_number)
    phone_number.to_s.gsub(/\D/, "") if phone_number
  end

  def notify_interview_start_change
    Mailer.notify_interview_start_change(self, solicitor).deliver_later if solicitor
  end

  def send_solicitor_case_details
    Mailer.send_solicitor_case_details(self, solicitor).deliver_later if solicitor
  end
end
