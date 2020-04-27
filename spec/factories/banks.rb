FactoryBot.define do
  factory :bank do
    sequence(:slug) { |n| "bank_#{n}" }

    name { "Bank Name" }
  end
end
