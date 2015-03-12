require 'rails_helper'

RSpec.describe DefenceRequestPolicy do
  subject { DefenceRequestPolicy.new user, defreq }

  let (:actions) { group_actions + allowed_actions }

  context "Custody Suite Officers" do
    let(:user)          { FactoryGirl.create(:cso_user) }
    let(:group_actions) {
      [:index, :new, :create, :refresh_dashboard,
       :solicitors_search, :view_open_requests,
       :view_draft_requests, :view_accepted_requests]
    }

    context "with a new DR" do
      let (:allowed_actions) { [
        :show,
        :edit,
        :update,
        :close,
        :feedback,
        :case_details_edit,
        :detainee_details_edit,
        :solicitor_details_edit,
        :add_case_time_of_arrival
      ] }
      let (:defreq) { FactoryGirl.build(:defence_request) }
      specify{ expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with a draft DR" do
      let (:allowed_actions) { [
        :show,
        :edit,
        :update,
        :close,
        :feedback,
        :interview_start_time_edit,
        :case_details_edit,
        :detainee_details_edit,
        :solicitor_details_edit
      ] }
      let (:defreq) { FactoryGirl.create(:defence_request) }
      specify{ expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with an opened DR" do
      let (:allowed_actions) { [
        :show,
        :edit,
        :update,
        :close,
        :feedback,
        :case_details_edit,
        :detainee_details_edit
      ] }
      let (:defreq) { FactoryGirl.create(:defence_request, :opened) }
      specify { expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with an accepted DR" do
      let (:allowed_actions) { [
        :show,
        :edit,
        :update,
        :close,
        :feedback,
        :resend_details,
        :case_details_edit,
        :detainee_details_edit,
        :solicitor_time_of_arrival
      ] }
      let (:defreq) { FactoryGirl.create(:defence_request, :accepted) }
      specify{ expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with a closed DR" do
      let (:allowed_actions) { [] }
      let! (:defreq) { FactoryGirl.create(:defence_request, :closed) }
      specify { expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    describe "scope" do
      let (:defreq) { FactoryGirl.create(:defence_request) }
      it "returns all of the requests" do
        expect(Pundit.policy_scope(user, DefenceRequest)).to eq [defreq]
      end
    end
  end

  context "Call Center Operatives" do
    let(:user) { FactoryGirl.create(:cco_user) }
    let(:group_actions) {
      [:index, :refresh_dashboard, :view_open_requests,
       :view_draft_requests, :view_accepted_requests]
    }

    context "with a draft DR" do
      let (:allowed_actions) { [
        :show,
        :open,
        :close,
        :feedback,
      ] }
      let (:defreq) { FactoryGirl.create(:defence_request) }
      specify { expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "DR that they are assigned to" do
      context "with an opened DR" do
        let (:allowed_actions) { [
          :show,
          :edit,
          :dscc_number_edit,
          :update,
          :close,
          :feedback,
          :case_details_edit,
          :detainee_details_edit,
          :solicitor_details_edit
        ] }
        let! (:defreq) { FactoryGirl.create(:defence_request, :opened, cco: user) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "opened with a DR with dscc number" do
        let (:allowed_actions) { [
          :show,
          :edit,
          :dscc_number_edit,
          :update,
          :close,
          :feedback,
          :accept,
          :case_details_edit,
          :detainee_details_edit,
          :solicitor_details_edit
        ] }
        let! (:defreq) { FactoryGirl.create(:defence_request, :opened, :with_dscc_number, cco: user) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "with an accepted DR" do
        let (:allowed_actions) { [
          :edit,
          :show,
          :update,
          :close,
          :feedback,
          :resend_details,
          :detainee_details_edit,
          :case_details_edit,
          :solicitor_time_of_arrival
        ] }
        let (:defreq) { FactoryGirl.create(:defence_request, :accepted, cco: user) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "with a closed DR" do
        let (:allowed_actions) { [] }
        let! (:defreq) { FactoryGirl.create(:defence_request, :closed, cco: user) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end
    end

    context "DR they are not assigned to" do
      context "with an opened DR" do
        let (:other_cco) { FactoryGirl.create(:cco_user)}
        let (:allowed_actions) { [
          :show,
          :close,
          :feedback,
        ] }
        let! (:defreq) { FactoryGirl.create(:defence_request, :opened, cco: other_cco) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "with an accepted DR" do
        let (:other_cco) { FactoryGirl.create(:cco_user)}
        let (:allowed_actions) { [
          :show,
          :close,
          :feedback,
        ] }
        let! (:defreq) { FactoryGirl.create(:defence_request, :opened, cco: other_cco) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "with a closed DR" do
        let (:other_cco) { FactoryGirl.create(:cco_user)}
        let (:allowed_actions) { [] }
        let! (:defreq) { FactoryGirl.create(:defence_request, :closed, cco: other_cco) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end
    end

    describe "scope" do
      let (:defreq) { FactoryGirl.create(:defence_request) }
      it "returns all of the requests" do
        expect(Pundit.policy_scope(user, DefenceRequest)).to eq [defreq]
      end
    end
  end

  context "Solicitors" do
    let (:defreq) { FactoryGirl.create(:defence_request) }
    let(:user) { FactoryGirl.create(:solicitor_user)}
    let(:group_actions) { [:index, :view_accepted_requests, :refresh_dashboard] }

    context "DR they are assigned to" do
      context "with an accepted DR" do
        let (:allowed_actions) { [
          :show,
          :solicitor_time_of_arrival,
          :solicitor_time_of_arrival_from_show
        ] }
        let (:defreq) { FactoryGirl.create(:defence_request, :accepted, solicitor: user) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "with a closed DR" do
        let (:allowed_actions) { [:show ] }
        let (:defreq) { FactoryGirl.create(:defence_request, :closed, solicitor: user) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end
    end

    context "DR they are not assigned to" do
      let (:other_solicitor) { FactoryGirl.create(:solicitor_user) }

      context "with an accepted DR" do
        let (:allowed_actions) { [] }
        let (:defreq) { FactoryGirl.create(:defence_request, :accepted, solicitor: other_solicitor) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end

      context "with a closed DR" do
        let (:allowed_actions) { [] }
        let (:defreq) { FactoryGirl.create(:defence_request, :accepted, solicitor: other_solicitor) }
        specify { expect(subject).to permit_actions_and_forbid_all_others actions }
      end
    end

    describe "scope" do
      let (:defreq) { FactoryGirl.create(:defence_request) }
      let (:defreq2) { FactoryGirl.create(:defence_request) }

      it "returns empty list" do
        defreq.update(solicitor: user)
        expect(Pundit.policy_scope(user, DefenceRequest)).to eq [defreq]
      end
    end
  end

end
