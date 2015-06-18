require "rails_helper"

RSpec.describe ServiceUser, type: :model do
  describe ".from_omniauth_user" do
    subject { described_class.from_omniauth_user(omni_auth_user) }

    context "when user passed in is nil" do
      let(:omni_auth_user) { nil }

      it { is_expected.to be nil }
    end

    context "when user passed in is a valid user" do
      let(:roles) { %w(role1 role2) }
      let(:valid_organisation) do
        {
          "type" => "custody_suite",
          "roles" => roles
        }
      end
      let(:organisations) do
        [
          {
            "type" => "some_unknown_type",
            "roles" => [ "does_not_matter" ]
          },
          valid_organisation
        ]
      end
      let(:omni_auth_user) { double(uid: "UID", name: "NAME", email: "EMAIL", organisations: organisations) }

      %i(uid name email organisations).each do |method|
        it "delegates :#{method} to the passed user object" do
          expect(subject.send(method)).to eql(omni_auth_user.send(method))
        end
      end

      describe "an organisation is selected and roles become available" do
        context "when there is an organisation with allowed type" do
          it "the assigned organisation is the selected one" do
            expect(subject.organisation).to eql(valid_organisation)
          end

          it "exposes the organisation roles" do
            expect(subject.roles).to eql(roles)
          end
        end

        context "when there is no allowed organisation type" do
          let(:organisations) do
            [
              {
                "type" => "some_unknown_type",
                "roles" => [ "does_not_matter" ]
              }
            ]
          end

          it "the assigned organisation is nil" do
            expect(subject.organisation).to be nil
          end

          it "roles are empty" do
            expect(subject.roles).to be_empty
          end
        end
      end
    end
  end
end
