FactoryGirl.define do
  factory :dscc_number do
    year_and_month { Time.now.to_date.beginning_of_month }
    sequence(:number) {|i| i }
  end
end
