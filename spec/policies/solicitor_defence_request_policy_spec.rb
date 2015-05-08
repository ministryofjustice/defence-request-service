require "rails_helper"

RSpec.describe SolicitorDefenceRequestPolicy do
  let!(:context) { PolicyContext.new defreq, user }

  subject { SolicitorDefenceRequestPolicy.new(user, context) }

  let (:actions) { group_actions + allowed_actions }

  context "Solicitors" do
    let (:defreq) { FactoryGirl.create(:defence_request) }
    let(:user) { FactoryGirl.create(:solicitor_user)}
    let(:group_actions) { [] }

    context "DR they are assigned to" do
      context "with an accepted DR" do
        let (:allowed_actions) { [
          :show,
          :solicitor_time_of_arrival,
          :solicitor_time_of_arrival_from_show
        ] }
        let (:defreq) { FactoryGirl.create(:defence_request, :accepted, solicitor_uid: user.uid) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "with an aborted DR" do
        let (:allowed_actions) { [:show ] }
        let (:defreq) { FactoryGirl.create(:defence_request, :aborted, solicitor_uid: user.uid) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end
    end

    context "DR their organisation is assigned to" do
      context "not in draft state" do
        let(:allowed_actions) { [ :show ] }
        let(:defreq) { FactoryGirl.create(:defence_request, :accepted, organisation_uid: user.organisation_uids.first) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "in draft state" do
        let(:allowed_actions) { [] }
        let(:defreq) { FactoryGirl.create(:defence_request, :draft, organisation_uid: user.organisation_uids.first) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end
    end

    context "DR they are not assigned to" do
      let (:other_solicitor) { FactoryGirl.create(:solicitor_user) }

      context "with an accepted DR" do
        let (:allowed_actions) { [] }
        let (:defreq) { FactoryGirl.create(:defence_request, :accepted, solicitor_uid: other_solicitor.uid) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "with an aborted DR" do
        let (:allowed_actions) { [] }
        let (:defreq) { FactoryGirl.create(:defence_request, :aborted, solicitor: other_solicitor) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end
    end

    describe "Scope" do
      let! (:draft_dr) { FactoryGirl.create(:defence_request, :draft, solicitor_uid: user.uid) }
      let! (:accepted_dr) { FactoryGirl.create(:defence_request, :accepted) }
      let! (:accepted_and_assigned_dr) do
        FactoryGirl.create(:defence_request, :accepted,
                           solicitor_uid: user.uid,
                           organisation_uid: user.organisation_uids.first
        )
      end

      describe "resolve" do
        it "returns DRs that are assigned to the solicitor and have been accepted" do
          context = PolicyContext.new(DefenceRequest, user)
          policy_scope = SolicitorDefenceRequestPolicy::Scope.new(user, context)

          expect(policy_scope.resolve).to eq [accepted_and_assigned_dr]
        end
      end
    end
  end
end