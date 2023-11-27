 require 'rails_helper'

RSpec.describe "/institutions", type: :request do
  include RequestHelper

  let(:institution) { create(:institution) }

  let(:valid_attributes) {{ name: 'Kiwibank', slug: 'kiwibank', headers_in_file: true, date_format: '%m/%d/%Y', expenses_negative: true, headers: Institution::REQUIRED_HEADERS }}
  let(:invalid_attributes) { { name: '' } }

  describe "GET /index" do
    it "renders a successful response" do
      get institutions_url, headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get institution_url(institution), headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_institution_url, headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      get edit_institution_url(institution), headers: valid_auth_header
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Institution" do
        expect {
          post institutions_url, params: { institution: valid_attributes }, headers: valid_auth_header
        }.to change(Institution, :count).by(1)
      end

      it "redirects to the created institution" do
        post institutions_url, params: { institution: valid_attributes }, headers: valid_auth_header
        expect(response).to redirect_to(institution_url(Institution.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Institution" do
        expect {
          post institutions_url, params: { institution: invalid_attributes }, headers: valid_auth_header
        }.to change(Institution, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post institutions_url, params: { institution: invalid_attributes }, headers: valid_auth_header
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { { slug: "other_institution", name: "Institution Number 2" } }

      it "updates the requested institution" do
        patch institution_url(institution), params: { institution: new_attributes }, headers: valid_auth_header
        institution.reload
        institution.slug == 'other_institution'
        institution.name == 'Institution Number 2'
      end

      it "redirects to the institution" do
        patch institution_url(institution), params: { institution: new_attributes }, headers: valid_auth_header
        institution.reload
        expect(response).to redirect_to(institution_url(institution))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        patch institution_url(institution), params: { institution: invalid_attributes }, headers: valid_auth_header
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested institution" do
      delete institution_url(institution), headers: valid_auth_header
      expect(Institution.count).to eq(0)
      # expect {
      # }.to change(Institution, :count).by(-1)
    end

    it "redirects to the institutions list" do
      delete institution_url(institution), headers: valid_auth_header
      expect(response).to redirect_to(institutions_url)
    end
  end
end
