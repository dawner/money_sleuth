FactoryBot.define do
  factory :account do
    name { "Account Name" }
    account_type { 0 }
    institution
  end
end
