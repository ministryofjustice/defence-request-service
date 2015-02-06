class DefenceRequest < ActiveRecord::Base
  include ActiveModel::Transitions

  state_machine auto_scopes: true do
    state :created # first one is initial state
    state :open
    state :closed
    state :finished

    event :open do
      transitions from: [:created], to: :open
    end

    event :finish do
      transitions from: [:open], to: :finished
    end

    event :close do
      transitions from: [:created, :open], to: :closed
    end
  end

  before_save :format_phone_number

  validates :solicitor_name,
            :solicitor_firm,
            :detainee_name,
            :allegations,
            :phone_number,
            :gender,
            :date_of_birth,
            :time_of_arrival,
            :custody_number, presence: true

  audited

  SCHEMES = [ 'No Scheme',
              'Brighton Scheme 1',
              'Brighton Scheme 2',
              'Brighton Scheme 3']

  private

  def format_phone_number
    self.phone_number = self.phone_number.gsub(/\D/, '')
  end


end
