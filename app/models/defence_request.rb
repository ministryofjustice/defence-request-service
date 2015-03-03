class DefenceRequest < ActiveRecord::Base
  include ActiveModel::Transitions

  belongs_to :solicitor, class_name: :User
  belongs_to :cco, class_name: :User

  delegate :email, to: :solicitor, prefix: true, allow_nil: true

  after_update :notify_interview_start_change, if: :interview_start_time_changed?

  after_commit :remove_builders

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
      transitions from: [:opened], to: :accepted, guard: :dscc_number?
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

  validate do |defence_request|
    GovukTimeDateValidator.new(defence_request, :solicitor_time_of_arrival, @solicitor_time_of_arrival_builder).validate
    GovukTimeDateValidator.new(defence_request, :time_of_arrival, @time_of_arrival_builder).validate
    GovukTimeDateValidator.new(defence_request, :interview_start_time, @interview_start_time_builder).validate
    GovukDateValidator.new(defence_request, :date_of_birth, @date_of_birth_builder).validate
  end

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

  def resend_details
    send_solicitor_case_details
  end

  def date_of_birth=(new_date)
    @date_of_birth_builder = DateBuilder.new(new_date)

    if @date_of_birth_builder.valid?
      super(@date_of_birth_builder.value)
    end
  end

  def date_of_birth
    if @date_of_birth_builder
      @date_of_birth_builder
    else
      super
    end
  end

  def solicitor_time_of_arrival=(new_date)
    @solicitor_time_of_arrival_builder = DateTimeBuilder.new(new_date)

    if @solicitor_time_of_arrival_builder.valid?
      super(@solicitor_time_of_arrival_builder.value)
    end
  end

  def solicitor_time_of_arrival
    if @solicitor_time_of_arrival_builder
      @solicitor_time_of_arrival_builder
    else
      super
    end
  end

  def time_of_arrival=(new_date)
    @time_of_arrival_builder = DateTimeBuilder.new(new_date)

    if @time_of_arrival_builder.valid?
      super(@time_of_arrival_builder.value)
    end
  end

  def time_of_arrival
    if @time_of_arrival_builder
      @time_of_arrival_builder
    else
      super
    end
  end

  def interview_start_time=(new_date)
    @interview_start_time_builder = DateTimeBuilder.new(new_date)

    if @interview_start_time_builder.valid?
      super(@interview_start_time_builder.value)
    end
  end

  def interview_start_time
    if @interview_start_time_builder
      @interview_start_time_builder
    else
      super
    end
  end

  private

  def remove_builders
    @interview_start_time_builder = nil
    @time_of_arrival_builder =  nil
    @solicitor_time_of_arrival_builder =  nil
  end

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
