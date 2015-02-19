class DefenceRequest < ActiveRecord::Base
  include ActiveModel::Transitions

  belongs_to :solicitor, class_name: :User
  belongs_to :cco, class_name: :User

  delegate :email, to: :solicitor, prefix: true, allow_nil: true

  after_update :notify_interview_start_change, if: :interview_start_time_changed?

  scope :has_solicitor, ->(solicitor) { where(solicitor: solicitor) }

  state_machine auto_scopes: true do
    state :created # first one is initial state
    state :opened
    state :accepted
    state :closed
    state :finished

    event :open do
      transitions from: [:created], to: :opened
    end

    event :accept, success: :send_solicitor_case_details do
      transitions from: [:opened], to: :accepted
    end

    event :finish do
      transitions from: [:opened, :accepted], to: :finished
    end

    event :close do
      transitions from: [:created, :opened, :accepted], to: :closed
    end
  end

  before_save :format_phone_number

  validates :detainee_name,
            :allegations,
            :gender,
            :detainee_age,
            :time_of_arrival,
            :custody_number, presence: true

  validates :scheme, presence: true, if: :duty_solicitor?

  validates :solicitor_name,
            :solicitor_firm,
            :phone_number, presence: true, if: :own_solicitor?

  validates :feedback, feedback: true

  audited

  SCHEMES = [ 'No Scheme',
              'Brighton Scheme 1',
              'Brighton Scheme 2',
              'Brighton Scheme 3']

  def duty_solicitor?
    solicitor_type == 'duty'
  end

  def own_solicitor?
    solicitor_type == 'own'
  end

  def date_of_birth_day
    date_of_birth.day if date_of_birth
  end

  def date_of_birth_month
    date_of_birth.month if date_of_birth
  end

  def date_of_birth_year
    date_of_birth.year if date_of_birth
  end

  def time_of_arrival_hour
    time_of_arrival.hour if time_of_arrival
  end

  def time_of_arrival_minute
    time_of_arrival.min if time_of_arrival
  end

  def resend_details
    send_solicitor_case_details
  end

  private

  def format_phone_number
    self.phone_number = self.phone_number.gsub(/\D/, '')
  end

  def notify_interview_start_change
    Mailer.notify_interview_start_change(self, solicitor).deliver_now if solicitor
  end

  def send_solicitor_case_details
    Mailer.send_solicitor_case_details(self, solicitor).deliver_now if solicitor
  end
end
