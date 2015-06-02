require "rails_helper"

RSpec.describe CsoDefenceRequestPolicy do
  let!(:context) { PolicyContext.new defreq, user }

  subject { CsoDefenceRequestPolicy.new(user, context) }

  let (:actions) { group_actions + allowed_actions }

  context "Custody Suite Officers" do
    let (:defreq) { FactoryGirl.create(:defence_request) }
    let(:user)          { FactoryGirl.create(:cso_user) }
    let(:group_actions) { [
      :new,
      :create
    ] }

    context "with a new DR" do
      let (:allowed_actions) { [
        :show,
        :edit,
        :update,
        :queue,
        :add_case_time_of_arrival,
        :interview_start_time_edit
      ] }
      let (:defreq) { FactoryGirl.build(:defence_request) }
      specify{ expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with a draft DR" do
      let (:allowed_actions) { [
        :show,
        :edit,
        :update,
        :queue,
        :interview_start_time_edit
      ] }
      let (:defreq) { FactoryGirl.create(:defence_request, :draft) }
      specify{ expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with an acknowledged DR" do
      let (:allowed_actions) { [
        :show,
        :abort,
        :complete,
        :interview_start_time_edit
      ] }
      let (:defreq) { FactoryGirl.create(:defence_request, :acknowledged) }
      specify { expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with an accepted DR" do
      let (:allowed_actions) { [
        :show,
        :abort,
        :complete,
        :resend_details,
        :interview_start_time_edit,
        :solicitor_time_of_arrival
      ] }
      let (:defreq) { FactoryGirl.create(:defence_request, :accepted) }
      specify{ expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with an aborted DR" do
      let (:allowed_actions) { [] }
      let! (:defreq) { FactoryGirl.create(:defence_request, :aborted) }
      specify { expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    describe "Scope" do
      let (:defreq) { FactoryGirl.create(:defence_request) }

      describe "resolve" do
        it "returns DRs that are assigned to the solicitor and have been accepted" do
          context = PolicyContext.new(DefenceRequest, user)
          policy_scope = CsoDefenceRequestPolicy::Scope.new(user, context)

          expect(policy_scope.resolve).to eq [defreq]
        end
      end
    end
  end
end
