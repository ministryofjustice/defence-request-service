require "rails_helper"

require "timecop"

RSpec.describe DefenceRequestsHelper, type: :helper do

  describe "formatting Not given field" do
    context "when address is Not given" do
      context "i18n translation for Not given is specified" do
        it "returns the specified translation" do
          request = create(:defence_request)
          expect(helper.not_given_formatter(request, :detainee_address, "name_not_given")).to eq("Name not given")
        end
      end

      context "i18n translation is not specified" do
        it "returns 'Not given'" do
          request = create(:defence_request)
          expect(helper.not_given_formatter(request, :detainee_address)).to eq("Not given")
        end
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

  describe "formatting Not given date" do
    context "when date is Not given" do
      it "returns 'Not given'" do
        request = create(:defence_request)
        request.update(date_of_birth: nil)
        expect(helper.date_not_given_formatter(request, :date_of_birth)).to eq("Not given")
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
    let(:now) { Time.parse("2015-06-02 15:20 GMT")}
    let(:request) { create(:defence_request, interview_start_time: time) }
    subject do
      Timecop.freeze(now) do
        helper.interview_at(request)
      end
    end

    context "when blank" do
      let(:time) { nil }

      it "renders correctly" do
        is_expected.to eql(%[<dl class="time-at"><dt>Interview time</dt> <dd>pending</dd></dl>])
      end
    end

    context "when set" do
      context "is today" do
        let(:time) { Time.parse("2015-06-02 18:20 GMT") }

        it "renders just the time" do
          is_expected.to eql(%[<dl class="time-at"><dt>Interview at</dt> <dd>18:20</dd></dl>])
        end
      end

      context "is not today" do
        let(:time) { Time.parse("2015-06-03 18:20 GMT") }

        it "renders the date and the time" do
          is_expected.to eql(%[<dl class="time-at"><dt>Interview at</dt> <dd>18:20 3 June 2015</dd></dl>])
        end
      end
    end
  end

  describe "label_text_for_form" do
    context "when the label is optional" do
      it "renders the translation of the attribute name" do
        output = helper.label_text_for_form(attribute_name: "detainee_name", optional: true)
        expect(output).to eq("Detainee name <span class=\"aside\">(optional)</span>")
      end
    end

    context "when the label is required" do
      it "renders the translation of the attribute name" do
        output = helper.label_text_for_form(attribute_name: "detainee_name")
        expect(output).to eq("Detainee name")
      end
    end
  end
end
