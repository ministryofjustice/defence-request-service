require "rails_helper"

RSpec.describe DefenceRequestsHelper, type: :helper do

  describe "formatting not given field" do
    context "when address is not given" do
      it "returns 'not given'" do
        request = create(:defence_request)
        expect(helper.not_given_formatter(request, :detainee_address)).to eq("not given")
      end
    end

    context "when address present" do
      it "returns address as single line" do
        request = create(:defence_request, :with_detainee_address)
        expected = "House on the Hill, Letsby Avenue, Right up my street, London, Greater London, XX1 1XX"
        expect(helper.not_given_formatter(request, :detainee_address)).to eq(expected)
      end
    end
  end

  describe "formatting not given date" do
    context "when date is not given" do
      it "returns 'not given'" do
        request = create(:defence_request)
        request.update(date_of_birth: nil)
        expect(helper.date_not_given_formatter(request, :date_of_birth)).to eq("not given")
      end
    end

    context "when address present" do
      it "returns date as correctly formatted" do
        request = create(:defence_request, date_of_birth: Date.parse("1994-05-20"))
        expect(helper.date_not_given_formatter(request, :date_of_birth)).to eq("20 May 1994")
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
      context "interview time is today" do
        it "renders just the time" do
          time = Time.zone.now
          request = create(:defence_request, interview_start_time: time)
          expected = %[<dl class="time-at"><dt>Interview at</dt> <dd>#{time.to_s(:time)}</dd></dl>]
          expect(helper.interview_at(request)).to eq(expected)
        end
      end

      context "interview time is not today" do
        it "renders the date and the time" do
          time = Time.zone.now + 1.day
          request = create(:defence_request, interview_start_time: time)
          expected = %[<dl class="time-at"><dt>Interview at</dt> <dd>#{time.to_s(:short)}</dd></dl>]
          expect(helper.interview_at(request)).to eq(expected)
        end
      end
    end
  end

  describe "arriving_at" do
    context "when arrival time set" do
      context "arrival time is today" do
        it "renders just the time" do
          time = Time.zone.now
          request = create(:defence_request, solicitor_time_of_arrival: time)
          expected = %[<dl class="time-at"><dt>Arriving at</dt> <dd id="solicitor_time_of_arrival">#{time.to_s(:time)}</dd></dl>]
          expect(helper.arriving_at(request)).to eq(expected)
        end
      end

      context "arrival time is not today" do
        it "renders both the date and the time" do
          time = Time.zone.now + 1.day
          request = create(:defence_request, solicitor_time_of_arrival: time)
          expected = %[<dl class="time-at"><dt>Arriving at</dt> <dd id="solicitor_time_of_arrival">#{time.to_s(:short)}</dd></dl>]
          expect(helper.arriving_at(request)).to eq(expected)
        end
      end
    end
  end

end
