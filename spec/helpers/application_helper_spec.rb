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
        expect(helper.display_value("gender", "Male")).to eq("<dt>Gender</dt> <dd>Male</dd>")
      end
    end

    context "when id specified" do
      it "renders localized label and value with id set" do
        expect(helper.display_value("gender", "Male", id: "xyz")).to eq("<dt>Gender</dt> <dd id=\"xyz\">Male</dd>")
      end
    end
  end

  describe "date_and_time_formatter" do
    let(:date) { Time.parse("2015-05-28 15:50:21") }

    it "renders time and date in the correct format" do
      expect(helper.date_and_time_formatter(date)).to eql("15:50 28 May 2015")
    end
  end
end
