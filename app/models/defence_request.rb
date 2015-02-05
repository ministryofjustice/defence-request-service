class DefenceRequest < ActiveRecord::Base
  include SimpleStates

  self.initial_state = :open
  states :open, :closed
  event :close,  :from => :open, :to => :closed

  scope :open, -> { where(state: :open) }

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
