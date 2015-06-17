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
      let(:organisations) do
        [
          {
            "type" => "some_unknown_type",
            "roles" => [ "does_not_matter" ]
          },
          {
            "type" => "custody_suite",
            "roles" => roles
          }
        ]
      end
      let(:omni_auth_user) { double(uid: "UID", name: "NAME", email: "EMAIL", organisations: organisations) }

      %i(uid name email organisations).each do |method|
        it "delegates :#{method} to the passed user object" do
          expect(subject.send(method)).to eql(omni_auth_user.send(method))
        end
      end

      describe "roles are extracted from organisations" do
        describe "only custody_suite organisation users have access" do
          it "exposes roles from the organisation" do
            expect(subject.roles).to match_array(roles)
          end
        end

        describe "all other organisations have no access" do
          let(:organisations) do
            [
              {
                "type" => "some_unknown_type",
                "roles" => [ "does_not_matter" ]
              }
            ]
          end

          it "does not expose any roles" do
            expect(subject.roles).to be_empty
          end
        end
      end
    end
  end
end
