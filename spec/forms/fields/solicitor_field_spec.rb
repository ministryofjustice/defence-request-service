require 'rails_helper'

RSpec.describe SolicitorField do

  context "from persisted value" do
    subject { SolicitorField.from_persisted_value solicitor }
    context "persisted value is present" do
      let(:solicitor) { FactoryGirl.create(:solicitor_user) }

      it "has the same email as the original" do
        expect(subject.email).to eql solicitor.email
      end
    end

    context "persisted value is nil" do
      let(:solicitor) { nil }

      it "has no fields set" do
        expect(subject.email).to be_nil
      end
    end
  end

  context "from params" do
    subject { SolicitorField.new params }


    context "user exists in the system with a matching email" do
      let(:solicitor) { FactoryGirl.create(:solicitor_user)}
      let(:params) { { email: solicitor.email } }

      it "has correct attributes, and solicitor" do
        expect(subject).to be_valid
        expect(subject.email).to eql params[:email]
        expect(subject.solicitor).to eql solicitor
      end
    end

    context "no user exits for the given email" do
      let(:params) { { email: "eamonn.holmes@example.com" } }

      it "has correct attributes, but no solicitor" do
        expect(subject).to be_valid
        expect(subject.email).to eql params[:email]
        expect(subject.solicitor).to be_nil
      end
    end
  end

  context "methods" do
    context "value" do
      context "solicitor email exists" do
        let(:solicitor) { FactoryGirl.create(:solicitor_user)}
        subject { SolicitorField.new email: solicitor.email}

        it "returns a solicitor" do
          expect(subject.value).to eql solicitor
        end
      end

      context "solicitor id exist, but email does not" do
        let(:solicitor) { FactoryGirl.create(:solicitor_user)}
        subject { SolicitorField.new solicitor_id: solicitor.id}

        it "returns a solicitor" do
          expect(subject.value).to eql solicitor
        end
      end

      context "no attributes are provided" do
        subject { SolicitorField.new }

        it "return nil" do
          expect(subject.value).to be_nil
        end
      end

      context "solicitor does not exist" do
        subject { SolicitorField.new email: "eamonn.holmes@example.com" }

        it "returns nil" do
          expect(subject.value).to be_nil
        end
      end
    end

    context "present?" do
      context "no fields" do
        subject { SolicitorField.new }

        it "returns false" do
          expect(subject).to_not be_present
        end
      end

      context "some fields" do
        subject { SolicitorField.new email: "I am not necessarily valid, but I am present" }

        it "returns true" do
          expect(subject).to be_present
        end
      end
    end
  end
end
