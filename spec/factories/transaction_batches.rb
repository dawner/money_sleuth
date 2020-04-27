FactoryBot.define do
  factory :transaction_batch do
    bank
    bank_file { "link.to.file" }
  end
end
