require "rails_helper"
Rails.application.load_tasks

RSpec.describe "Recipes", type: :request do
  describe "GET /recipes" do
    subject(:get_recipes) { get("/recipes", params: params) }
    let(:params) { {} }

    it "returns status 200" do
      get_recipes
      expect(response.status).to eq(200)
    end

    context "when there is no chosen ingredient" do
      it "returns an empty array" do
        get_recipes
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "when there is one ingredient" do
      before do
        json_file_path = Rails.root.join('spec', 'fixtures', 'files', 'recipes-en.json.gz')

        stub_request(:get, "https://pennylane-interviewing-assets-20220328.s3.eu-west-1.amazonaws.com/recipes-en.json.gz")
          .to_return(body: File.open(json_file_path))

        Rake::Task['json_import:import'].invoke
      end

      after do
        Rake::Task['json_import:import'].reenable
      end

      let(:params) do
        {
          name: "egg"
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
  end
end
