require "rails_helper"

RSpec.describe BalanceEntriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/balance_entries").to route_to("balance_entries#index")
    end

    it "routes to #new" do
      expect(get: "/balance_entries/new").to route_to("balance_entries#new")
    end

    it "routes to #show" do
      expect(get: "/balance_entries/1").to route_to("balance_entries#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/balance_entries/1/edit").to route_to("balance_entries#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/balance_entries").to route_to("balance_entries#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/balance_entries/1").to route_to("balance_entries#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/balance_entries/1").to route_to("balance_entries#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/balance_entries/1").to route_to("balance_entries#destroy", id: "1")
    end
  end
end
