 require 'rails_helper'

RSpec.describe "/transaction_batches", type: :request do
  include RequestHelper

  let!(:transaction_batch) { create(:transaction_batch) }

  let(:account) { create(:account) }
  let(:file){ Rack::Test::UploadedFile.new(Rails.root.join('spec/files/example_bank_file.csv')) }
  let(:valid_attributes){{ account_id: account.id, file: file }}
  let(:invalid_attributes){{ account_id: nil, file: nil }}

  describe "GET /index" do
    it "renders a successful response" do
      create(:transaction_batch)
      get transaction_batches_url, headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get transaction_batch_url(transaction_batch), headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_transaction_batch_url, headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new TransactionBatch" do
        expect {
          post transaction_batches_url, params: { transaction_batch: valid_attributes }, headers: valid_auth_header
        }.to change(TransactionBatch, :count).by(1)
      end

      it "creates some new transactions" do
        expect {
          post transaction_batches_url, params: { transaction_batch: valid_attributes }, headers: valid_auth_header
        }.to change(Transaction, :count).by(3) # 3 valid transaction lines in file
      end

      it "redirects to the created transaction_batch" do
        post transaction_batches_url, params: { transaction_batch: valid_attributes }, headers: valid_auth_header
        expect(response).to redirect_to(transaction_batch_url(TransactionBatch.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new TransactionBatch" do
        expect {
          post transaction_batches_url, params: { transaction_batch: invalid_attributes }, headers: valid_auth_header
        }.to change(TransactionBatch, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post transaction_batches_url, params: { transaction_batch: invalid_attributes }, headers: valid_auth_header
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested transaction_batch" do
      expect {
        delete transaction_batch_url(transaction_batch), headers: valid_auth_header
      }.to change(TransactionBatch, :count).by(-1)
    end

    it "redirects to the transaction_batches list" do
      delete transaction_batch_url(transaction_batch), headers: valid_auth_header
      expect(response).to redirect_to(transaction_batches_url)
    end
  end
end
