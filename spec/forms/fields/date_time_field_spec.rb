require "rails_helper"

RSpec.describe DateTimeField do

  context "from persisted value" do
    subject { DateTimeField.from_persisted_value datetime }

    context "persisted value is present" do
      let(:datetime) { DateTime.parse "13-04-1992 9:50" }

      it "has the same fields as the original" do
        date = Date.parse subject.date
        expect(date.year).to eql datetime.year
        expect(date.month).to eql datetime.month
        expect(date.day).to eql datetime.day
        expect(subject.hour).to eql "%02d" % datetime.hour
        expect(subject.min).to eql "%02d" % datetime.min
      end
    end

    context "persisted value is nil" do
      let(:datetime) { nil }

      it "has no fields set" do
        expect(subject.date).to be_nil
        expect(subject.hour).to be_nil
        expect(subject.min).to be_nil
      end
    end
  end

  context "from params" do
    subject { DateTimeField.new params }

    context "valid params" do
      let(:params) { { date: "13 Apr 1992", hour: "9", min: "50" } }

      it "is valid, with correct attributes" do
        expect(subject).to be_valid
        expect(subject.date).to eql params[:date]
        expect(subject.hour).to eql params[:hour]
        expect(subject.min).to eql params[:min]
      end
    end

    context "invalid params" do
      let(:params) { { date: "I", hour: "BROKEN", min: "!"}}

      it "is invalid, with errors set" do
        expect(subject).to_not be_valid
        expect(subject.errors.count).to eql 1
      end

      context "no error proc provided" do
        it "uses the default activereord error message" do
          expect(subject).to_not be_valid
          expect(subject.errors[:base]).to eql ["is invalid"]
        end
      end

      context "with an error proc"  do
        it "uses the message from the error proc" do
          subject.set_error_message_lookup_proc! Proc.new { "INVALID!" }
          expect(subject).to_not be_valid
          expect(subject.errors[:base]).to eql ["INVALID!"]
        end
      end
    end
  end

  context "methods" do
    context "value" do
      context "valid object" do
        subject { DateTimeField.new date: "13 Apr 1992", hour: "9", min: "50" }

        it "returns a datetime object" do
          expect(subject.value.class).to eql DateTime
        end
      end

      context "invalid object" do
        subject { DateTimeField.new date: "BROKEN", hour: "VERY", min: "MUCH" }

        it "returns nil" do
          expect(subject.value).to be_nil
        end
      end

      context "built with ambiguous date" do
        subject { DateTimeField.new date: "4/5/1992", hour: "9", min: "50" }

        it "uses little endian parsing (British format)" do
          expect(subject).to be_valid
          expect(subject.value.day).to eql 4
          expect(subject.value.month).to eql 5
        end
      end
    end

    context "present?" do
      context "no fields filled in" do
        subject { DateTimeField.new }

        it "returns false" do
          expect(subject).to_not be_present
        end
      end

      context "some filled in" do
        subject { DateTimeField.new date: "I am filled in but not necessarily valid" }

        it "returns true" do
          expect(subject).to be_present
        end
      end
    end

    context "blank?" do
      context "no fields filled in" do
        subject { DateTimeField.new }

        it "returns true" do
          expect(subject).to be_blank
        end
      end

      context "some filled in" do
        subject { DateTimeField.new date: "I am filled in but not necessarily valid" }

        it "returns false" do
          expect(subject).to_not be_blank
        end
      end
    end
  end
end
