 require 'rails_helper'

RSpec.describe "/categories", type: :request do
  include RequestHelper

  let!(:category) { create(:category) }

  let(:valid_attributes) {{ name: 'Groceries', transaction_type: :expense, keywords: ['market'] }}
  let(:invalid_attributes) {{ name: '' }}

  describe "GET /index" do
    it "renders a successful response" do
      get categories_url, headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get category_url(category), headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_category_url, headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      get edit_category_url(category), headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Category" do
        expect {
          post categories_url, params: { category: valid_attributes }, headers: valid_auth_header
        }.to change(Category, :count).by(1)
      end

      it "redirects to the created category" do
        post categories_url, params: { category: valid_attributes }, headers: valid_auth_header
        expect(response).to redirect_to(category_url(Category.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Category" do
        expect {
          post categories_url, params: { category: invalid_attributes }, headers: valid_auth_header
        }.to change(Category, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post categories_url, params: { category: invalid_attributes }, headers: valid_auth_header
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { { name: "New name" } }

      it "updates the requested category" do
        patch category_url(category), params: { category: new_attributes }, headers: valid_auth_header
        category.reload
        category.name = 'New name'
      end

      it "redirects to the category" do
        patch category_url(category), params: { category: new_attributes }, headers: valid_auth_header
        category.reload
        expect(response).to redirect_to(categories_url)
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        patch category_url(category), params: { category: invalid_attributes }, headers: valid_auth_header
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested category" do
      expect {
        delete category_url(category), headers: valid_auth_header
      }.to change(Category, :count).by(-1)
    end

    it "redirects to the categories list" do
      delete category_url(category), headers: valid_auth_header
      expect(response).to redirect_to(categories_url)
    end
  end
end
