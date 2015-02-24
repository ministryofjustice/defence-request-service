require 'rails_helper'

RSpec.describe DefenceRequestPolicy do
  subject { DefenceRequestPolicy.new user, defreq }

  let (:defreq) { DefenceRequest.new }

  context "Custody Suite Officers" do
    let(:user)          { FactoryGirl.create(:cso_user) }
    let(:group_actions) {
      [:index, :show, :new, :create, :refresh_dashboard,
       :solicitors_search, :view_open_requests,
       :view_created_requests, :view_accepted_requests]
    }

    context "with a new DR" do
      let (:allowed_actions) { [
        :edit,
        :update,
        :close,
        :feedback,
        :case_details_edit,
        :detainee_details_edit,
        :solicitor_details_edit
      ] }
      let (:defreq) { FactoryGirl.build(:defence_request) }
      let (:actions) { group_actions + allowed_actions }
      specify{ expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with a created DR" do
      let (:allowed_actions) { [
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
      let (:actions) { group_actions + allowed_actions }
      specify{ expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with an opened DR" do
      let (:allowed_actions) { [
        :edit,
        :update,
        :close,
        :feedback,
        :case_details_edit,
        :detainee_details_edit,
        :solicitor_details_edit
      ] }
      let (:defreq) { FactoryGirl.create(:defence_request, :opened) }
      let (:actions) { group_actions + allowed_actions }
      specify { expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with an accepted DR" do
      let (:allowed_actions) { [
        :edit,
        :update,
        :close,
        :feedback,
        :resend_details,
        :case_details_edit,
        :detainee_details_edit,
        :solicitor_details_edit,
        :solicitor_time_of_arrival
      ] }
      let (:defreq) { FactoryGirl.create(:defence_request, :accepted) }
      let (:actions) { group_actions + allowed_actions }
      specify{ expect(subject).to permit_actions_and_forbid_all_others actions }
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
      [:index, :show, :refresh_dashboard, :view_open_requests,
       :view_created_requests, :view_accepted_requests]
    }

    context "with a created DR" do
      let (:allowed_actions) { [
        :open,
        :close,
        :feedback,
        :solicitor_details_edit
      ] }
      let (:defreq) { FactoryGirl.create(:defence_request) }
      let (:actions) { group_actions + allowed_actions }
      specify { expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with an opened DR" do
      let (:allowed_actions) { [
        :edit,
        :dscc_number_edit,
        :update,
        :close,
        :feedback,
        :case_details_edit,
        :detainee_details_edit,
        :solicitor_details_edit
      ] }
      subject { DefenceRequestPolicy.new(User.first, defreq) }
      let! (:defreq) { FactoryGirl.create(:defence_request, :opened) }
      let (:actions) { group_actions + allowed_actions }
      specify { expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with a DR with dscc number" do
      let (:allowed_actions) { [
        :edit,
        :dscc_number_edit,
        :update,
        :close,
        :feedback,
        :accepted,
        :accept,
        :case_details_edit,
        :detainee_details_edit,
        :solicitor_details_edit
      ] }
      subject { DefenceRequestPolicy.new(User.first, defreq) }
      let! (:defreq) { FactoryGirl.create(:defence_request, :with_dscc_number) }
      let (:actions) { group_actions + allowed_actions }
      specify { expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with an accepted DR" do
      let (:allowed_actions) { [
        :close,
        :feedback,
        :resend_details,
        :detainee_details_edit,
        :case_details_edit,
        :solicitor_details_edit,
        :solicitor_time_of_arrival
      ] }
      let (:defreq) { FactoryGirl.create(:defence_request, :accepted) }
      let (:actions) { group_actions + allowed_actions }
      specify { expect(subject).to permit_actions_and_forbid_all_others actions }
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

    context "with an assigned DR" do
      let (:allowed_actions) { [
        :show,
        :solicitor_time_of_arrival,
        :solicitor_time_of_arrival_from_show
      ] }
      let (:defreq) { FactoryGirl.create(:defence_request, :accepted, solicitor: user) }
      let (:actions) { group_actions + allowed_actions }
      specify { expect(subject).to permit_actions_and_forbid_all_others actions }
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
