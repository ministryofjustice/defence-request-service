FactoryGirl.define do
  factory :organisation, class: Drs::AuthClient::Models::Organisation do
    skip_create

    uid { SecureRandom.uuid }
    name { "Some organisation" }
    type { %w(law_firm call_centre call_centre).sample }

    initialize_with do
      new({uid: uid, name: name, type: type})
    end
  end
end