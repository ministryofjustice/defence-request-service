FactoryGirl.define do
  factory :user, class: ServiceUser do
    to_create { |instance| instance }

    initialize_with {
      omni_auth_user = Omniauth::Dsds::User.new(
        uid: SecureRandom.uuid,
        name: "Example User",
        email: "user@example.com",
        organisations: []
      )

      ServiceUser.from_omniauth_user(omni_auth_user)
    }
  end

  factory :cco_user, class: ServiceUser do
    to_create { |instance| instance }

    initialize_with {
      omni_auth_user = Omniauth::Dsds::User.new(
        uid: SecureRandom.uuid,
        name: "Example CCO User",
        email: "cco_user@example.com",
        organisations: [
          {
            "uid" => SecureRandom.uuid,
            "name" => "Example call centre",
            "type" => "drs_call_center",
            "roles" => ["cco"]
          }
        ]
      )

      ServiceUser.from_omniauth_user(omni_auth_user)
    }
  end

  factory :cso_user, class: ServiceUser do
    to_create { |instance| instance }

    transient do
      organisation { build(:organisation, :custody_suite) }
    end

    initialize_with {
      omni_auth_user = Omniauth::Dsds::User.new(
        uid: SecureRandom.uuid,
        name: "Example CSO User",
        email: "cso_user@example.com",
        organisations: [
          {
            "uid" => organisation.uid,
            "name" => organisation.name,
            "type" => organisation.type,
            "roles" => ["cso"]
          }
        ]
      )

      ServiceUser.from_omniauth_user(omni_auth_user)
    }
  end

  factory :solicitor_user, class: ServiceUser do
    to_create { |instance| instance }
    transient do
      organisation_uids { [SecureRandom.uuid] }
    end

    initialize_with {
      omni_auth_user = Omniauth::Dsds::User.new(
        uid: SecureRandom.uuid,
        name: "Example Solicitor User",
        email: "solicitor_user@example.com",
        organisations: [
          {
            "uid" => organisation_uids.first,
            "name" => "Example law firm",
            "type" => "law_firm",
            "roles" => ["solicitor"]
          }
        ]
      )

      ServiceUser.from_omniauth_user(omni_auth_user)
    }
  end

end
