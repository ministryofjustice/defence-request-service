require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do

  describe "#display_value" do
    context "when value blank" do
      it "renders localized label and '-' for value" do
        expect(helper.display_value("age", "")).to eq("<dt>Age</dt> <dd>-</dd>")
      end
    end

    context "when value present" do
      it "renders localized label and value" do
        expect(helper.display_value("age", 12)).to eq("<dt>Age</dt> <dd>12</dd>")
      end
    end

    context "when id specified" do
      it "renders localized label and value with id set" do
        expect(helper.display_value("age", 12, id: "xyz")).to eq("<dt>Age</dt> <dd id=\"xyz\">12</dd>")
      end
    end
  end
end
