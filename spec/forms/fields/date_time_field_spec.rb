require 'rails_helper'

RSpec.describe DateTimeField do

  context "from persisted value" do
    subject { DateTimeField.from_persisted_value datetime }

    context "persisted value is present" do
      let(:datetime) { DateTime.parse "13-04-1992 9:50" }

      it "has the same fields as the original" do
        expect(subject.year).to eql datetime.year
        expect(subject.month).to eql datetime.month
        expect(subject.day).to eql datetime.day
        expect(subject.hour).to eql datetime.hour
        expect(subject.min).to eql datetime.min
      end
    end

    context "persisted value is nil" do
      let(:datetime) { nil }

      it "has no fields set" do
        expect(subject.year).to be_nil
        expect(subject.month).to be_nil
        expect(subject.day).to be_nil
        expect(subject.hour).to be_nil
        expect(subject.min).to be_nil
      end
    end
  end

  context "from params" do
    subject { DateTimeField.new params }

    context "valid params" do
      let(:params) { { day: "13", month: "4", year: "1992", hour: "9", min: "50" } }

      it "is valid, with correct attributes" do
        expect(subject).to be_valid
        expect(subject.year).to eql params[:year]
        expect(subject.month).to eql params[:month]
        expect(subject.day).to eql params[:day]
        expect(subject.hour).to eql params[:hour]
        expect(subject.min).to eql params[:min]
      end
    end

    context "invalid params" do
      let(:params) { { day: "I", month: "AM", year: "TOTALLY", hour: "BROKEN", min: "!"}}

      it "is invalid, with errors set" do
        expect(subject).to_not be_valid
        expect(subject.errors.count).to eql 6
        expect(subject.errors[:base]).to eql ["Invalid Date or Time"]
        expect(subject.errors[:day]).to eql ["is not a number"]
        expect(subject.errors[:month]).to eql ["is not a number"]
        expect(subject.errors[:year]).to eql ["is not a number"]
        expect(subject.errors[:hour]).to eql ["is not a number"]
        expect(subject.errors[:min]).to eql ["is not a number"]
      end
    end
  end

  context "methods" do
    context "value" do
      context "valid object" do
        subject { DateTimeField.new day: "13", month: "4", year: "1992", hour: "9", min: "50" }

        it "returns a datetime object" do
          expect(subject.value.class).to eql DateTime
        end
      end

      context "invalid object" do
        subject { DateTimeField.new day: "I", month: "AM", year: "BROKEN", hour: "VERY", min: "MUCH" }

        it "returns nil" do
          expect(subject.value).to be_nil
        end
      end
    end

    context "present?" do
      context "no fields filled in" do
        subject { DateField.new }

        it "returns false" do
          expect(subject).to_not be_present
        end
      end

      context "some filled in" do
        subject { DateField.new day: "I am filled in but not necessarily valid" }

        it "returns true" do
          expect(subject).to be_present
        end
      end
    end

    context "blank?" do
      context "no fields filled in" do
        subject { DateField.new }

        it "returns true" do
          expect(subject).to be_blank
        end
      end

      context "some filled in" do
        subject { DateField.new day: "I am filled in but not necessarily valid" }

        it "returns false" do
          expect(subject).to_not be_blank
        end
      end
    end
  end

end
