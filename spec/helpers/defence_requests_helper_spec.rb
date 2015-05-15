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

  describe "interview_at" do
    context "when interview time blank" do
      it "renders correctly" do
        request = create(:defence_request)
        expected = %[<dl class="time-at"><dt>Interview time</dt> <dd>pending</dd></dl>]
        expect(helper.interview_at(request)).to eq(expected)
      end
    end
    context "when interview time set" do
      it "renders correctly" do
        request = create(:defence_request, :interview_start_time)
        expected = %[<dl class="time-at"><dt>Interview at</dt> <dd>01:01</dd></dl>]
        expect(helper.interview_at(request)).to eq(expected)
      end
    end
  end

  describe "arriving_at" do
    context "when arrival time set" do
      it "renders correctly" do
        request = create(:defence_request, :solicitor_time_of_arrival)
        expected = %[<dl class="time-at"><dt>Arriving at</dt> <dd id="solicitor_time_of_arrival">01:01</dd></dl>]
        expect(helper.arriving_at(request)).to eq(expected)
      end
    end
  end

end
