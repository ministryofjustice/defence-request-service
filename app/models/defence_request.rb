class DefenceRequest < ActiveRecord::Base

  phony_normalize :phone_number, default_country_code: 'GB'

  validates :detainee_surname,
            :detainee_first_name,
            :allegations,
            length: { minimum: 2 }

  validates :gender, :date_of_birth, :time_of_arrival, :custody_number, presence: true
  validates :phone_number, phony_plausible: true

  audited

  SCHEMES = [ 'No Scheme',
              'Brighton Scheme 1',
              'Brighton Scheme 2',
              'Brighton Scheme 3']

end
