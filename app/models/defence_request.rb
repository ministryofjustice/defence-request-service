class DefenceRequest < ActiveRecord::Base
  include ActiveModel::Transitions

  attr_accessor :cco, :solicitor

  after_update :notify_interview_start_change, if: :interview_start_time_changed?

  scope :accepted_aborted_or_completed, -> { where(state: ["accepted", "aborted", "completed"]) }
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

    ACTIVE_STATES = :draft, :queued, :acknowledged, :accepted
    CLOSED_STATES = :aborted, :completed

    event :queue do
      transitions from: [:draft], to: :queued
    end

    event :acknowledge do
      transitions from: [:queued], to: :acknowledged
    end

    event :accept, success: :send_solicitor_case_details do
      transitions from: [:acknowledged], to: :accepted, guard: [:dscc_number?]
    end

    event :abort do
      transitions from: [:queued, :acknowledged, :accepted], to: :aborted
    end

    event :complete do
      transitions from: [:acknowledged, :accepted], to: :completed
    end
  end

  validates :reason_aborted, presence: true, if: :aborted?

  validates :detainee_name, presence: true, unless: :detainee_name_not_given?
  validates :detainee_address, presence: true, unless: :detainee_address_not_given?
  validates :date_of_birth, presence: true, unless: :date_of_birth_not_given?

  validates :offences,
            :custody_number,
            :gender,
            :time_of_arrival, presence: true



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

  def active?
    ACTIVE_STATES.include? state.to_sym
  end

  def closed?
    CLOSED_STATES.include? state.to_sym
  end

  private

  def notify_interview_start_change
    Mailer.notify_interview_start_change(self, solicitor).deliver_later if solicitor
  end

  def send_solicitor_case_details
    Mailer.send_solicitor_case_details(self, solicitor).deliver_later if solicitor
  end
end
