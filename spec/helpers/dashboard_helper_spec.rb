require "rails_helper"

RSpec.describe DashboardHelper, type: :helper do

  describe "rendering a custody_number" do
    it "prefixes the custody_number with CN:" do
      expect(helper.render_custody_number("AN123")).to eq("CN:&nbsp;AN123")
    end
  end
end
