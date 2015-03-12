FactoryGirl.define do
  factory :user do |user|
    sequence(:email)            {|n| "barry#{n}@factory.example.com" }
    user.password               "password"
    user.password_confirmation  "password"
  end

  factory :cso_user, parent: :user do
    role :cso
  end

  factory :cco_user, parent: :user do
    role :cco
  end

  factory :solicitor_user, parent: :user do
    role :solicitor
  end
end
