class DefenceRequest < ActiveRecord::Base
  include ActiveModel::Transitions

  state_machine auto_scopes: true do
    state :created # first one is initial state
    state :opened
    state :closed
    state :finished

    event :open do
      transitions from: [:created], to: :opened
    end

    event :finish do
      transitions from: [:opened], to: :finished
    end

    event :close do
      transitions from: [:created, :opened], to: :closed
    end
  end

  before_save :format_phone_number

  validates :detainee_name,
            :allegations,
            :gender,
            :date_of_birth,
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

  private

  def format_phone_number
    self.phone_number = self.phone_number.gsub(/\D/, '')
  end

end
