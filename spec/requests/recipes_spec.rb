require "rails_helper"

RSpec.describe "Recipes", type: :request do
  describe "GET /recipes" do
    it "returns status 200" do
      get("/recipes")
      expect(response.status).to eq(200)
    end
  end
end
