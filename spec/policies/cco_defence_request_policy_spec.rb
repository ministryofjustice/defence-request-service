require "rails_helper"

RSpec.describe CcoDefenceRequestPolicy   do
  let!(:context) { PolicyContext.new defreq, user }

  subject { CcoDefenceRequestPolicy.new(user, context) }

  let (:actions) { group_actions + allowed_actions }

  context "Call Center Operatives" do
    let (:defreq) { FactoryGirl.create(:defence_request) }
    let(:user) { FactoryGirl.create(:cco_user) }
    let(:group_actions) {
      []
    }

    context "with a draft DR" do
      let (:allowed_actions) { [] }
      let (:defreq) { FactoryGirl.create(:defence_request) }

      specify { expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "DR that they are assigned to" do
      context "with an acknowledged DR" do
        let (:allowed_actions) { [
          :show,
          :edit,
          :dscc_number_edit,
          :update,
          :edit_solicitor_details
        ] }
        let! (:defreq) { FactoryGirl.create(:defence_request, :acknowledged, cco_uid: user.uid) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "with an acknowledged DR with a dscc number" do
        let (:allowed_actions) { [
          :show,
          :edit,
          :dscc_number_edit,
          :update,
          :accept,
          :edit_solicitor_details
        ] }
        let! (:defreq) { FactoryGirl.create(:defence_request, :acknowledged, :with_dscc_number, cco_uid: user.uid) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "with an accepted DR" do
        let (:allowed_actions) { [
          :edit,
          :show,
          :update,
          :resend_details,
          :solicitor_time_of_arrival,
          :edit_solicitor_details
        ] }
        let (:defreq) { FactoryGirl.create(:defence_request, :accepted, cco_uid: user.uid) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "with an aborted DR" do
        let (:allowed_actions) { [
          :show
        ] }
        let! (:defreq) { FactoryGirl.create(:defence_request, :aborted, cco: user) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end
    end

    context "DR they are not assigned to" do
      context "with an acknowledged DR" do
        let (:other_cco) { FactoryGirl.create(:cco_user) }
        let (:allowed_actions) { [
          :show
        ] }
        let! (:defreq) { FactoryGirl.create(:defence_request, :acknowledged, cco: other_cco) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "with an accepted DR" do
        let (:other_cco) { FactoryGirl.create(:cco_user) }
        let (:allowed_actions) { [
          :show
        ] }
        let! (:defreq) { FactoryGirl.create(:defence_request, :acknowledged, cco: other_cco) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "with an aborted DR" do
        let (:other_cco) { FactoryGirl.create(:cco_user) }
        let (:allowed_actions) { [
          :show
        ] }
        let! (:defreq) { FactoryGirl.create(:defence_request, :aborted, cco: other_cco) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end
    end

    describe "Scope" do
      describe "resolve" do
        let (:draft_defreq) { FactoryGirl.create(:defence_request) }
        let (:other_defreq) { FactoryGirl.create(:defence_request, :queued) }

        it "returns DRs that are assigned to the solicitor and have been accepted" do
          context = PolicyContext.new(DefenceRequest, user)
          policy_scope = CcoDefenceRequestPolicy::Scope.new(user, context)

          expect(policy_scope.resolve).to eq [other_defreq]
        end
      end
    end
  end
end