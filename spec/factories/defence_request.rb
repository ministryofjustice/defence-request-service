FactoryGirl.define do
  factory :defence_request, aliases: [:own_solicitor] do
    solicitor_type 'own'
    sequence(:solicitor_name) { |n| "solicitor_name-#{n}" }
    sequence(:solicitor_firm) { |n| "solicitor_firm-#{n}" }
    scheme 1
    phone_number '447810480123'
    sequence(:detainee_name) { |n| "detainee_name-#{n}" }
    gender %w(male female).sample
    date_of_birth Date.current - 21.years
    sequence(:custody_number) { |n| "custody_number-#{n}" }
    allegations ['Murder','Theft','Drunk','Hate Crime'].sample
    time_of_arrival DateTime.current
    sequence(:comments) { |n| "commenty-comments-are here: #{n}" }
    adult [nil, true, false].sample
    appropriate_adult [true, false].sample
  end

  trait :created do
    state 'created'
  end

  trait :open do
    state 'open'
  end
end
