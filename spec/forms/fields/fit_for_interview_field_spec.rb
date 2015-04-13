require 'rails_helper'

RSpec.describe FitForInterviewField do

  context "from persisted value" do
    subject { FitForInterviewField.from_persisted_value bool }
    context "persisted value for true" do
      let(:bool) { true }

      it "has the same email as the original" do
        expect(subject.fit_for_interview).to eql 'yes'
      end
    end

    context "persisted value for false" do
      let(:bool) { false }

      it "has the same email as the original" do
        expect(subject.fit_for_interview).to eql 'no'
      end
    end
  end

  context "from params" do
    subject { FitForInterviewField.new params }


    context "with value yes" do
      let(:params) { { fit_for_interview: 'yes' } }

      it "has correct attribute" do
        expect(subject.fit_for_interview).to eql 'yes'
      end
    end

    context "with value no" do
      let(:params) { { fit_for_interview: 'no' } }

      it "has correct attribute" do
        expect(subject.fit_for_interview).to eql 'no'
      end
    end
  end

  context "methods" do
    context "value" do
      context "for 'no'" do
        subject { FitForInterviewField.new fit_for_interview: 'no' }

        it "returns 'no'" do
          expect(subject.value).to eql false
        end
      end

      context "for 'yes'" do
        subject { FitForInterviewField.new fit_for_interview: 'yes' }

        it "returns 'yes'" do
          expect(subject.value).to eql true
        end
      end
    end

    context "present?" do
      context "no value specified" do
        subject { FitForInterviewField.new }

        it "returns false" do
          expect(subject).to_not be_present
        end
      end

      context "some fields" do
        subject { FitForInterviewField.new fit_for_interview: "yes" }

        it "returns true" do
          expect(subject).to be_present
        end
      end
    end

    context "blank?" do
      context "no value specified" do
        subject { FitForInterviewField.new }

        it "returns true" do
          expect(subject).to be_blank
        end
      end

      context "some fields" do
        subject { FitForInterviewField.new fit_for_interview: "yes" }

        it "returns false" do
          expect(subject).to_not be_blank
        end
      end
    end
  end
end
