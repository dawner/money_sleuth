require "rails_helper"

RSpec.describe TransactionBatchesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/transaction_batches").to route_to("transaction_batches#index")
    end

    it "routes to #new" do
      expect(get: "/transaction_batches/new").to route_to("transaction_batches#new")
    end

    it "routes to #show" do
      expect(get: "/transaction_batches/1").to route_to("transaction_batches#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/transaction_batches/1/edit").to route_to("transaction_batches#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/transaction_batches").to route_to("transaction_batches#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/transaction_batches/1").to route_to("transaction_batches#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/transaction_batches/1").to route_to("transaction_batches#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/transaction_batches/1").to route_to("transaction_batches#destroy", id: "1")
    end
  end
end
