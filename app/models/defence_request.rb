class DefenceRequest < ActiveRecord::Base
  include ActiveModel::Transitions

  belongs_to :solicitor, class_name: :User
  belongs_to :cco, class_name: :User
  belongs_to :dscc_number, autosave: true

  delegate :email, to: :solicitor, prefix: true, allow_nil: true

  after_update :notify_interview_start_change, if: :interview_start_time_changed?

  scope :has_solicitor, ->(solicitor) { where(solicitor: solicitor) }
  scope :not_draft, -> { where.not(state: 'draft') }
  scope :not_aborted, -> { where.not(state: 'aborted') }
  scope :accepted_or_aborted, -> { where(state: ['accepted', 'aborted']) }

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
      transitions from: [:acknowledged], to: :accepted, guard: [:dscc_number?, :solicitor_details?]
    end

    event :abort do
      transitions from: [:queued, :acknowledged, :accepted], to: :aborted
    end

    event :finish do
      transitions from: [:acknowledged, :accepted], to: :finished
    end

  end

  before_save :format_phone_number

  validates :reason_aborted, presence: true, if: :aborted?

  validates :solicitor_name,
            :solicitor_firm,
            :phone_number, presence: true, if: :own_solicitor?

  validates :scheme, presence: true, if: :duty_solicitor?

  validates :detainee_name,
            :allegations,
            :gender,
            :time_of_arrival,
            :custody_number, presence: true

  validates :detainee_age, numericality: true, presence: true

  validates_uniqueness_of :dscc_number_id, allow_nil: true

  audited

  SCHEMES = [ 'No Scheme',
              'Brighton Scheme 1',
              'Brighton Scheme 2',
              'Brighton Scheme 3']


  def resend_details
    send_solicitor_case_details
  end

  def duty_solicitor?
    solicitor_type == 'duty'
  end

  def own_solicitor?
    solicitor_type == 'own'
  end

  def dscc_number?
    dscc_number.present?
  end

  def solicitor_details?
    solicitor_name && solicitor_firm && phone_number
  end

  private

  def format_phone_number
    self.phone_number = self.phone_number.gsub(/\D/, '')
  end

  def notify_interview_start_change
    Mailer.notify_interview_start_change(self, solicitor).deliver_later if solicitor
  end

  def send_solicitor_case_details
    Mailer.send_solicitor_case_details(self, solicitor).deliver_later if solicitor
  end

end
