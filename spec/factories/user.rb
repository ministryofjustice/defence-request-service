FactoryGirl.define do
  factory :user, class: Omniauth::Dsds::User do
    to_create { |instance| instance }

    initialize_with {
      new(
        uid: SecureRandom.uuid,
        name: "Example User",
        email: "user@example.com",
        roles: [],
        organisation_uids: []
      )
    }
  end

  factory :cco_user, class: Omniauth::Dsds::User do
    to_create { |instance| instance }

    initialize_with {
      new(
        uid: SecureRandom.uuid,
        name: "Example CCO User",
        email: "cco_user@example.com",
        roles: ["cco"],
        organisation_uids: []
      )
    }
  end

  factory :cso_user, class: Omniauth::Dsds::User do
    to_create { |instance| instance }

    initialize_with {
      new(
        uid: SecureRandom.uuid,
        name: "Example CSO User",
        email: "cso_user@example.com",
        roles: ["cso"],
        organisation_uids: []
      )
    }
  end

  factory :solicitor_user, class: Omniauth::Dsds::User do
    to_create { |instance| instance }

    initialize_with {
      new(
        uid: SecureRandom.uuid,
        name: "Example Solicitor User",
        email: "solicitor_user@example.com",
        roles: ["solicitor"],
        organisation_uids: []
      )
    }
  end
end
