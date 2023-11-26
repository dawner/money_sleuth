FactoryBot.define do
  factory :institution do
    sequence(:slug) { |n| "institution_#{n}" }
    name { "Institution Name" }
    headers { Institution::REQUIRED_HEADERS }
    date_format { "%m/%d/%Y" }
    headers_in_file { true }
    expenses_negative { true }
  end
end
