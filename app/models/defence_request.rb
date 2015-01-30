class DefenceRequest < ActiveRecord::Base

  after_save :notify_dashboard

  phony_normalize :phone_number, default_country_code: 'GB'

  validates :solicitor_name,
            :solicitor_firm,
            :detainee_surname,
            :detainee_first_name,
            :allegations,
            length: { minimum: 5 }

  validates :gender, :date_of_birth, :time_of_arrival, :custody_number, :scheme, presence: true
  validates :phone_number, phony_plausible: true

  SCHEMES = [
    ['Brighton Scheme 1', 1],
    ['Brighton Scheme 2', 2],
    ['Brighton Scheme 3', 3]
  ]


  def notify_dashboard
    WebsocketRails[:defence_request_changes].trigger(:defence_request_change, self)
  end

end
