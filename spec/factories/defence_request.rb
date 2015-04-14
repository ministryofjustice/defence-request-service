FactoryGirl.define do
  now = DateTime.current
  twenty_one_years_ago = DateTime.current - 21.years

  factory :defence_request, aliases: [:own_solicitor] do
    solicitor_type 'own'
    sequence(:solicitor_name) { |n| "solicitor_name-#{n}" }
    sequence(:solicitor_firm) { |n| "solicitor_firm-#{n}" }
    scheme 1
    phone_number '447810480123'
    sequence(:detainee_name) { |n| "detainee_name-#{n}" }
    gender %w(male female).sample
    date_of_birth twenty_one_years_ago
    detainee_age 21
    sequence(:custody_number) { |n| "custody_number-#{n}" }
    allegations ['Murder','Theft','Drunk','Hate Crime'].sample
    time_of_arrival now
    sequence(:comments) { |n| "commenty-comments-are here: #{n}" }
    adult [nil, true, false].sample
    appropriate_adult [true, false].sample
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
    association :dscc_number
    association :cco, factory: :cco_user
  end

  trait :with_solicitor do
    association :solicitor, factory: :solicitor_user
  end

  trait :accepted do
    state 'accepted'
    association :dscc_number
    association :solicitor, factory: :solicitor_user
  end

  trait :aborted do
    association :dscc_number
    reason_aborted 'This has been closed for a reason.'
    state 'aborted'
  end

  trait :finished do
    state 'finished'
  end

  trait :with_dscc_number do
    association :dscc_number
  end
end
