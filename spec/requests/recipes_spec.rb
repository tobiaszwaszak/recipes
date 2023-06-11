require "rails_helper"

RSpec.describe "Recipes", type: :request do
  describe "GET /recipes" do
    subject(:get_recipes) { get("/recipes", params: params) }
    let(:params) { {} }

    before do
      json_file_path = Rails.root.join("spec", "fixtures", "files", "recipes-en.json.gz")

      stub_request(:get, "https://pennylane-interviewing-assets-20220328.s3.eu-west-1.amazonaws.com/recipes-en.json.gz")
        .to_return(body: File.open(json_file_path))

      Rake::Task["json_import:import"].invoke
    end

    after do
      Rake::Task["json_import:import"].reenable
    end

    it "returns status 200" do
      get_recipes
      expect(response.status).to eq(200)
    end

    context "when there is no chosen ingredient" do
      let(:params) do
        {
          ingredients: []
        }
      end

      it "returns an empty array" do
        get_recipes
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "when there is one ingredient" do
      let(:params) do
        {
          ingredients: ["egg"]
        }
      end

      it "returns array with expected 'Golden Sweet Cornbread' recipe" do
        get_recipes

        expect(JSON.parse(response.body).any? { |recipe| recipe["title"] == "Golden Sweet Cornbread" }).to be true
      end

      it "returns array with expected 'Diana's Hawaiian Bread Rolls' recipe" do
        get_recipes

        expect(JSON.parse(response.body).any? { |recipe| recipe["title"] == "Diana's Hawaiian Bread Rolls" }).to be true
      end
    end

    context "when there are multiple ingredients" do
      let(:params) do
        {
          ingredients: ["egg", "cornmeal"]
        }
      end

      it "returns array with 'Golden Sweet Cornbread' recipe" do
        get_recipes

        expect(JSON.parse(response.body).any? { |recipe| recipe["title"] == "Golden Sweet Cornbread" }).to be true
      end

      it "returns array without 'Diana's Hawaiian Bread Rolls' recipe" do
        get_recipes

        expect(JSON.parse(response.body).any? { |recipe| recipe["title"] == "Diana's Hawaiian Bread Rolls" }).to be false
      end
    end

    context "when there is no matching ingredient" do
      let(:params) do
        {
          ingredients: ["egg", "cornmeal", "foo"]
        }
      end

      it "returns an empty array" do
        get_recipes
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end
end
