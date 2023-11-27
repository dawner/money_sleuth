 require 'rails_helper'

RSpec.describe "/balance_entries", type: :request do
  include RequestHelper

  let!(:balance_entry) { create(:balance_entry) }
  let(:account) { create(:account) }

  # BalanceEntry. As you add validations to BalanceEntry, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes){{ posted_on: 1.day.ago, value: 3, account_id: account.id }}
  let(:invalid_attributes){{ posted_on: nil, value: 3, account_id: account.id }}

  describe "GET /index" do
    it "renders a successful response" do
      get balance_entries_url, headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_balance_entry_url, headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      get edit_balance_entry_url(balance_entry), headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new BalanceEntry" do
        expect {
          post balance_entries_url, params: { balance_entry: valid_attributes }, headers: valid_auth_header
        }.to change(BalanceEntry, :count).by(1)
      end

      it "redirects to the created balance_entry" do
        post balance_entries_url, params: { balance_entry: valid_attributes }, headers: valid_auth_header
        expect(response).to redirect_to(balance_entries_url)
      end
    end

    context "with invalid parameters" do
      it "does not create a new BalanceEntry" do
        expect {
          post balance_entries_url, params: { balance_entry: invalid_attributes }, headers: valid_auth_header
        }.to change(BalanceEntry, :count).by(0)
      end

      it "returns 422 with no updates" do
        post balance_entries_url, params: { balance_entry: invalid_attributes }, headers: valid_auth_header
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes){{ value: 8 }}

      it "updates the requested balance_entry" do
        patch balance_entry_url(balance_entry), params: { balance_entry: new_attributes }, headers: valid_auth_header
        balance_entry.reload
        expect(balance_entry.value_cents).to eq(800)
      end

      it "redirects to the balance_entry" do
        patch balance_entry_url(balance_entry), params: { balance_entry: new_attributes }, headers: valid_auth_header
        balance_entry.reload
        expect(response).to redirect_to(balance_entries_url)
      end
    end

    context "with invalid parameters" do
      it "returns 422 with no updates" do
        patch balance_entry_url(balance_entry), params: { balance_entry: invalid_attributes }, headers: valid_auth_header
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested balance_entry" do
      expect {
        delete balance_entry_url(balance_entry), headers: valid_auth_header
      }.to change(BalanceEntry, :count).by(-1)
    end

    it "redirects to the balance_entries list" do
      delete balance_entry_url(balance_entry), headers: valid_auth_header
      expect(response).to redirect_to(balance_entries_url)
    end
  end
end
