 require 'rails_helper'

RSpec.describe "/accounts", type: :request do
  include RequestHelper

  let!(:account) { create(:account, institution: institution) }
  let(:institution) { create(:institution) }

  let(:valid_attributes) {{ name: 'Account Name', account_type: :bank, institution_id: institution.id, active: true, headers_in_file: true, date_format: '%m/%d/%Y', headers: Account::DEFAULT_HEADERS }}
  let(:invalid_attributes) {{name: '', }}

  describe "GET /index" do
    it "renders a successful response" do
      get accounts_url, headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get account_url(account), headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_account_url, headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      get edit_account_url(account), headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Account" do
        expect {
          post accounts_url, params: { account: valid_attributes }, headers: valid_auth_header
        }.to change(Account, :count).by(1)
      end

      it "redirects to the created account" do
        post accounts_url, params: { account: valid_attributes }, headers: valid_auth_header
        expect(response).to redirect_to(account_url(Account.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Account" do
        expect {
          post accounts_url, params: { account: invalid_attributes }, headers: valid_auth_header
        }.to change(Account, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post accounts_url, params: { account: invalid_attributes }, headers: valid_auth_header
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
    let(:new_attributes) {{ name: 'New Name', account_type: :bank, institution_id: institution.id, active: true }}

      it "updates the requested account" do
        patch account_url(account), params: { account: new_attributes }, headers: valid_auth_header
        account.reload
        expect(account.name).to eq ('New Name')
      end

      it "redirects to the account" do
        patch account_url(account), params: { account: new_attributes }, headers: valid_auth_header
        expect(response).to redirect_to(account_url(account))
      end
    end

    context "with invalid parameters" do
      it "returns 422 with no updates" do
        patch account_url(account), params: { account: invalid_attributes }, headers: valid_auth_header
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested account" do
      account = Account.create! valid_attributes
      expect {
        delete account_url(account), headers: valid_auth_header
      }.to change(Account, :count).by(-1)
    end

    it "redirects to the accounts list" do
      account = Account.create! valid_attributes
      delete account_url(account), headers: valid_auth_header
      expect(response).to redirect_to(accounts_url)
    end
  end
end
