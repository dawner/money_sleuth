FactoryBot.define do
  factory :institution do
    sequence(:slug) { |n| "institution_#{n}" }

    name { "Institution Name" }
  end
end
