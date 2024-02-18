require 'rails_helper'

RSpec.describe CategoriseBatch, type: :interactor do
  subject { described_class.call(transaction_batch: transaction_batch) }

  let(:transaction_batch) { create(:transaction_batch, file: file, account: account) }
  let(:account){ create(:account, headers: headers) }
  let(:headers) { Account::DEFAULT_HEADERS }
  let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/files/#{file_name}")) }
  let(:file_name) { 'example_bank_file.csv' }

  describe '.call' do
    context 'when the transaction batch is valid' do
      context 'with only a default category setup' do
        it 'categorises the batch to default category, ignoring non zero values' do
          expect(subject).to be_a_success
          transactions = subject.transaction_batch.transactions
          expect(transactions.count).to eq(3)
          transactions.each { |t| expect(t.category).to eq(Category.default) }
        end
      end

      context 'with some category matches' do
        before do
          create(:category, name: 'Cafe', keywords: ['coffee', 'starbucks'])
          create(:category, name: 'Bank fees', keywords: ['refund'])
        end

        context 'for expenses as debits' do
          let(:file_name) { 'example_bank_file.csv' }

          it 'categorises the batch to matching categories as negative values' do
            expect(subject).to be_a_success
            transactions = subject.transaction_batch.transactions.order(:posted_on)
            expect(transactions.count).to eq(3)
            expect(transactions[0].category.name).to eq('Cafe')
            expect(transactions[0].value_cents).to eq(-450)
            expect(transactions[1].category.name).to eq('Bank fees')
            expect(transactions[1].value_cents).to eq(750)
            expect(transactions[2].category).to eq(Category.default)
            expect(transactions[2].value_cents).to eq(-120000)
          end
        end

        context 'for file with debits and credits' do
          let(:file_name) { 'example_bank_file_debit_credit_columns.csv' }
          let(:headers){ ['posted_on', 'description', 'expense_value', 'value'] }

          it 'categorises the batch to matching categories' do
            expect(subject).to be_a_success
            transactions = subject.transaction_batch.transactions.order(:posted_on)
            expect(transactions.count).to eq(3)
            expect(transactions[0].category.name).to eq('Cafe')
            expect(transactions[0].value_cents).to eq(-450)
            expect(transactions[1].category.name).to eq('Bank fees')
            expect(transactions[1].value_cents).to eq(750)
            expect(transactions[2].category).to eq(Category.default)
            expect(transactions[2].value_cents).to eq(-120000)
          end
        end

        context 'for expenses as credits' do
          let(:file_name) { 'example_bank_file_positive_value_expenses.csv' }
          let(:headers){ ['posted_on', 'description', 'expense_value'] }

          it 'categorises the batch to matching categories' do
            expect(subject).to be_a_success
            transactions = subject.transaction_batch.transactions.order(:posted_on)
            expect(transactions.count).to eq(3)
            expect(transactions[0].category.name).to eq('Cafe')
            expect(transactions[0].value_cents).to eq(-450)
            expect(transactions[1].category.name).to eq('Bank fees')
            expect(transactions[1].value_cents).to eq(750)
            expect(transactions[2].category).to eq(Category.default)
            expect(transactions[2].value_cents).to eq(-120000)
          end
        end
      end
    end

    context 'when the transaction batch is not valid' do
      before do
        allow(transaction_batch).to receive(:valid?).and_return(false)
      end

      it 'fails the context' do
        expect(subject).to be_a_failure
        expect(subject.errors).to eq(transaction_batch.errors)
      end
    end
  end
end