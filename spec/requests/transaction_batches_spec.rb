 require 'rails_helper'

RSpec.describe "/transaction_batches", type: :request do
  let(:valid_attributes) {
    bank = create(:bank)
    { bank_id: bank.id, bank_file: "link.to.file" }
  }

  let(:invalid_attributes) {
    {bank_id: nil, bank_file: nil }
  }

  describe "GET /index" do
    it "renders a successful response" do
      create(:transaction_batch)
      get transaction_batches_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      transaction_batch = create(:transaction_batch)
      get transaction_batch_url(transaction_batch)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_transaction_batch_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      transaction_batch = create(:transaction_batch)
      get edit_transaction_batch_url(transaction_batch)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new TransactionBatch" do
        expect {
          post transaction_batches_url, params: { transaction_batch: valid_attributes }
        }.to change(TransactionBatch, :count).by(1)
      end

      it "redirects to the created transaction_batch" do
        post transaction_batches_url, params: { transaction_batch: valid_attributes }
        expect(response).to redirect_to(transaction_batch_url(TransactionBatch.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new TransactionBatch" do
        expect {
          post transaction_batches_url, params: { transaction_batch: invalid_attributes }
        }.to change(TransactionBatch, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post transaction_batches_url, params: { transaction_batch: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { { bank_file: "link.to.another.file" } }

      it "updates the requested transaction_batch" do
        transaction_batch = create(:transaction_batch)
        patch transaction_batch_url(transaction_batch), params: { transaction_batch: new_attributes }
        transaction_batch.reload
        transaction_batch.bank_file == "link.to.another.file"
      end

      it "redirects to the transaction_batch" do
        transaction_batch = create(:transaction_batch)
        patch transaction_batch_url(transaction_batch), params: { transaction_batch: new_attributes }
        transaction_batch.reload
        expect(response).to redirect_to(transaction_batch_url(transaction_batch))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        transaction_batch = create(:transaction_batch)
        patch transaction_batch_url(transaction_batch), params: { transaction_batch: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested transaction_batch" do
      transaction_batch = create(:transaction_batch)
      expect {
        delete transaction_batch_url(transaction_batch)
      }.to change(TransactionBatch, :count).by(-1)
    end

    it "redirects to the transaction_batches list" do
      transaction_batch = create(:transaction_batch)
      delete transaction_batch_url(transaction_batch)
      expect(response).to redirect_to(transaction_batches_url)
    end
  end
end
