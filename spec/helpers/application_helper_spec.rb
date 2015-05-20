require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do

  describe "#display_value" do
    context "when value blank" do
      it "renders localized label and '-' for value" do
        expect(helper.display_value("gender", "")).to eq("<dt>Gender</dt> <dd>-</dd>")
      end
    end

    context "when value present" do
      it "renders localized label and value" do
        expect(helper.display_value("gender", 'Male')).to eq("<dt>Gender</dt> <dd>Male</dd>")
      end
    end

    context "when id specified" do
      it "renders localized label and value with id set" do
        expect(helper.display_value("gender", 'Male', id: "xyz")).to eq("<dt>Gender</dt> <dd id=\"xyz\">Male</dd>")
      end
    end
  end
end
