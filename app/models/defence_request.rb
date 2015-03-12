class DefenceRequest < ActiveRecord::Base
  include ActiveModel::Transitions

  belongs_to :solicitor, class_name: :User
  belongs_to :cco, class_name: :User

  delegate :email, to: :solicitor, prefix: true, allow_nil: true

  after_update :notify_interview_start_change, if: :interview_start_time_changed?

  scope :has_solicitor, ->(solicitor) { where(solicitor: solicitor) }

  state_machine auto_scopes: true do
    state :draft # first one is initial state
    state :opened
    state :accepted
    state :closed
    state :finished

    event :open do
      transitions from: [:draft], to: :opened
    end

    event :accept, success: :send_solicitor_case_details do
      transitions from: [:opened], to: :accepted, guard: :dscc_number?
    end

    event :finish do
      transitions from: [:opened, :accepted], to: :finished
    end

    event :close do
      transitions from: [:draft, :opened, :accepted], to: :closed
    end
  end

  before_save :format_phone_number

  validates :feedback, feedback: true

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
