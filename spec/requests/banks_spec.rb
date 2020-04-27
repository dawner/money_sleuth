 require 'rails_helper'

RSpec.describe "/banks", type: :request do
  let(:valid_attributes) { { slug: "bank", name: "Top bank" } }

  let(:invalid_attributes) { { slug: nil, name: nil } }

  describe "GET /index" do
    it "renders a successful response" do
      create(:bank)
      get banks_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      bank = create(:bank)
      get bank_url(bank)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_bank_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      bank = create(:bank)
      get edit_bank_url(bank)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Bank" do
        expect {
          post banks_url, params: { bank: valid_attributes }
        }.to change(Bank, :count).by(1)
      end

      it "redirects to the created bank" do
        post banks_url, params: { bank: valid_attributes }
        expect(response).to redirect_to(bank_url(Bank.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Bank" do
        expect {
          post banks_url, params: { bank: invalid_attributes }
        }.to change(Bank, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post banks_url, params: { bank: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { { slug: "other_bank", name: "Bank Number 2" } }

      it "updates the requested bank" do
        bank = create(:bank)
        patch bank_url(bank), params: { bank: new_attributes }
        bank.reload
        bank.slug == 'other_bank'
        bank.name == 'Bank Number 2'
      end

      it "redirects to the bank" do
        bank = create(:bank)
        patch bank_url(bank), params: { bank: new_attributes }
        bank.reload
        expect(response).to redirect_to(bank_url(bank))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        bank = create(:bank)
        patch bank_url(bank), params: { bank: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested bank" do
      bank = create(:bank)
      expect {
        delete bank_url(bank)
      }.to change(Bank, :count).by(-1)
    end

    it "redirects to the banks list" do
      bank = create(:bank)
      delete bank_url(bank)
      expect(response).to redirect_to(banks_url)
    end
  end
end
