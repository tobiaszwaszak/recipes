require "rails_helper"

RSpec.describe RecipesSearchService do
  describe "#call" do
    context "when ingredients are present" do
      let(:params) { {ingredients: ["milk", "sugar"]} }

      before do
        json_file_path = Rails.root.join("spec", "fixtures", "files", "recipes-en.json.gz")

        stub_request(:get, "https://pennylane-interviewing-assets-20220328.s3.eu-west-1.amazonaws.com/recipes-en.json.gz")
          .to_return(body: File.open(json_file_path))

        Rake::Task["json_import:import"].invoke
      end

      after do
        Rake::Task["json_import:import"].reenable
      end

      it "returns an array of recipe representations" do
        expect(RecipesSearchService.new(params: params).call).to be_an(Array)
      end

      it "returns expected numer or recipes" do
        expect(RecipesSearchService.new(params: params).call.size).to eq(4)
      end

      it "has proper keys representation" do
        expect(RecipesSearchService.new(params: params).call.first.keys)
          .to match([:id, :title, :cook_time, :prep_time, :ingredients, :ratings, :cuisine, :category, :author, :image])
      end
    end

    context "when ingredients are not present" do
      let(:params) { {} }

      it "returns an empty array" do
        expect(RecipesSearchService.new(params: params).call).to be_empty
      end
    end
  end
end
