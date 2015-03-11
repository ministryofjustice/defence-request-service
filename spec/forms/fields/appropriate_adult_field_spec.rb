require 'rails_helper'

RSpec.describe AppropriateAdultField do

  context "from persisted value" do
    subject { AppropriateAdultField.from_persisted_value bool }
    context "persisted value for true" do
      let(:bool) { true }

      it "has the same email as the original" do
        expect(subject.appropriate_adult).to eql 'yes'
      end
    end

    context "persisted value for false" do
      let(:bool) { false }

      it "has the same email as the original" do
        expect(subject.appropriate_adult).to eql 'no'
      end
    end
  end

  context "from params" do
    subject { AppropriateAdultField.new params }


    context "with value yes" do
      let(:params) { { appropriate_adult: 'yes' } }

      it "has correct attribute" do
        expect(subject.appropriate_adult).to eql 'yes'
      end
    end

    context "with value no" do
      let(:params) { { appropriate_adult: 'no' } }

      it "has correct attribute" do
        expect(subject.appropriate_adult).to eql 'no'
      end
    end
  end

  context "methods" do
    context "value" do
      context "for 'no'" do
        subject { AppropriateAdultField.new appropriate_adult: 'no' }

        it "returns 'no'" do
          expect(subject.value).to eql false
        end
      end

      context "for 'yes'" do
        subject { AppropriateAdultField.new appropriate_adult: 'yes' }

        it "returns 'yes'" do
          expect(subject.value).to eql true
        end
      end
    end

    context "present?" do
      context "no value specified" do
        subject { AppropriateAdultField.new }

        it "returns false" do
          expect(subject).to_not be_present
        end
      end

      context "some fields" do
        subject { AppropriateAdultField.new appropriate_adult: "yes" }

        it "returns true" do
          expect(subject).to be_present
        end
      end
    end
  end
end
