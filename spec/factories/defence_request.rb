FactoryGirl.define do
  now = DateTime.new(2001,1,1,1,1)
  twenty_one_years_ago = DateTime.current - 21.years

  factory :defence_request, aliases: [:own_solicitor] do
    solicitor_type 'own'
    sequence(:solicitor_name) { |n| "solicitor_name-#{n}" }
    sequence(:solicitor_firm) { |n| "solicitor_firm-#{n}" }
    scheme 1
    phone_number '447810480123'
    sequence(:detainee_name) { |n| "detainee_name-#{n}" }
    gender 'male'
    date_of_birth twenty_one_years_ago
    detainee_age 21
    sequence(:custody_number) { |n| "custody_number-#{n}" }
    offences 'Theft'
    time_of_arrival now
    sequence(:comments) { |n| "commenty-comments-are here: #{n}" }
    adult [nil, true, false].sample
    appropriate_adult false
  end

  trait :duty_solicitor do
    solicitor_type 'duty'
    solicitor_name nil
    solicitor_firm nil
    scheme 'No Scheme'
    phone_number ''
  end

  trait :draft do
    state 'draft'
  end

  trait :queued do
    state 'queued'
  end

  trait :acknowledged do
    state 'acknowledged'
    association :cco, factory: :cco_user
  end

  trait :with_solicitor do
    association :solicitor, factory: :solicitor_user
  end

  trait :accepted do
    state 'accepted'
    dscc_number '123456'
    association :solicitor, factory: :solicitor_user
  end

  trait :aborted do
    dscc_number '123456'
    reason_aborted 'This has been closed for a reason.'
    state 'aborted'
  end

  trait :finished do
    state 'finished'
  end

  trait :with_dscc_number do
    dscc_number '123456'
  end

  trait :appropriate_adult do
    appropriate_adult true
    appropriate_adult_reason 'They look underage'
  end

  trait :interview_start_time do
    interview_start_time now
  end

  trait :solicitor_time_of_arrival do
    solicitor_time_of_arrival now
  end

  trait :with_address do
    house_name "House on the Hill"
    address_1 "Letsby Avenue"
    address_2 "Right up my street"
    city "London"
    county "Greater London"
    postcode "XX1 1XX"
  end

  trait :with_circumstance_of_arrest do
    circumstances_of_arrest "Caught red handed"
  end

  trait :with_investigating_officer do
    investigating_officer_name "Dave Mc.Copper"
    investigating_officer_shoulder_number "987654"
    investigating_officer_contact_number "0207 111 0000"
  end

  trait :with_custody_address do
    custody_address "The Nick"
  end

  trait :with_time_of_arrest do
    time_of_arrest now
  end
end
