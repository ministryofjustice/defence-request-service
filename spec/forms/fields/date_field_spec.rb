require "rails_helper"

RSpec.describe DateField do

  context "from persisted value" do
    subject { DateField.from_persisted_value date }
    context "presisted value is present" do
      let(:date) { Date.parse "13-04-1992" }

      it "has the same fields as the original" do
        expect(subject.year).to eql date.year
        expect(subject.month).to eql date.month
        expect(subject.day).to eql date.day
      end
    end

    context "presisted value is nil" do
      let(:date) { nil }

      it "has no fields set" do
        expect(subject.year).to be_nil
        expect(subject.month).to be_nil
        expect(subject.day).to be_nil
      end
    end
  end

  context "from params" do
    subject { DateField.new params }

    context "valid params" do
      let(:params) { { day: "13", month: "4", year: "1992" } }

      it "is valid, with correct attributes" do
        expect(subject).to be_valid
        expect(subject.day).to eql params[:day]
        expect(subject.month).to eql params[:month]
        expect(subject.year).to eql params[:year]
      end
    end

    context "invalid params" do
      let (:params) { { day: "I", month: "AM", year: "BROKEN" } }

      it "is invalid, with errors set" do
        expect(subject).to_not be_valid
        expect(subject.errors.count).to eql 4
        expect(subject.errors[:base]).to eql ["Invalid Date"]
        expect(subject.errors[:day]).to eql ["is not a number"]
        expect(subject.errors[:month]).to eql ["is not a number"]
        expect(subject.errors[:year]).to eql ["is not a number"]
      end
    end
  end

  context "methods" do
    context "value" do
      context "valid object" do
        subject { DateField.new day: "13", month: "4", year: "1992" }

        it "returns a date object" do
          expect(subject.value.class).to eql Date
        end
      end

      context "invalid object" do
        subject { DateField.new day: "I", month: "AM", year: "BROKEN" }

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
