FactoryBot.define do
  factory :transaction_batch do
    institution
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/files/example_bank
      _file.csv')) }
  end
end
