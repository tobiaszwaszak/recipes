require "rails_helper"

RSpec.describe "JSON Import Task", type: :task do
  before do
    json_file_path = Rails.root.join("spec", "fixtures", "files", "recipes-en.json.gz")

    stub_request(:get, "https://pennylane-interviewing-assets-20220328.s3.eu-west-1.amazonaws.com/recipes-en.json.gz")
      .to_return(body: File.open(json_file_path))
  end

  after do
    Rake::Task["json_import:import"].reenable
  end

  it "handles inaccessible JSON file gracefully" do
    expect {
      Rake::Task["json_import:import"].invoke
    }.not_to raise_error
  end

  it "create data based on JSON file" do
    expect {
      Rake::Task["json_import:import"].invoke
    }.to change { Recipe.count }.by(7)
      .and change { Author.count }.by(7)
      .and change { Category.count }.by(7)
      .and change { Cuisine.count }.by(1)
      .and change { RecipeIngredient.count }.by(51)
  end

  context "when some data already exist" do
    it "doesnt create new data" do
      Author.create(name: "bluegirl")

      expect {
        Rake::Task["json_import:import"].invoke
      }.to change { Author.count }.by(6)
    end
  end
end
