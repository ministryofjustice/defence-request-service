FactoryGirl.define do
  factory :organisation, class: Drs::AuthClient::Models::Organisation do
    skip_create

    uid { SecureRandom.uuid }
    tel { Faker::PhoneNumber.phone_number}
    name { Faker::Company.name }
    type { %w(law_firm call_centre).sample }

    trait :law_firm do
      type "law_firm"
    end

    initialize_with do
      new({uid: uid, name: name, type: type})
    end
  end
end
