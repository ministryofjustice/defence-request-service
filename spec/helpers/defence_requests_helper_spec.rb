require "rails_helper"

RSpec.describe DefenceRequestsHelper, type: :helper do

  describe "formatting detainee address" do
    context "when address blank" do
      it "returns 'Not given'" do
        request = create(:defence_request)
        expect(helper.detainee_address(request)).to eq("Not given")
      end
    end

    context "when address present" do
      it "returns address as single line" do
        request = create(:defence_request, :with_address)
        expected = "House on the Hill, Letsby Avenue, Right up my street, London, Greater London, XX1 1XX"
        expect(helper.detainee_address(request)).to eq(expected)
      end
    end
  end
end
