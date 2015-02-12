require 'rails_helper'

RSpec.describe DefenceRequestPolicy do
  subject { DefenceRequestPolicy.new user, defreq }

  let (:defreq) { DefenceRequest.new }

  context "Custody Suite Officers" do
    let(:user)          { FactoryGirl.create(:cso_user) }
    let(:group_actions) { [:index, :new, :create, :refresh_dashboard, :solicitors_search, :dashboard_view] }

    context "with a new DR" do
      let (:defreq) { FactoryGirl.build(:defence_request) }
      let (:actions) { group_actions + [:edit, :update, :close, :feedback] }
      specify{ expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with a created DR" do
      let (:defreq) { FactoryGirl.create(:defence_request) }
      let (:actions) { group_actions + [:edit, :update, :close, :feedback, :interview_start_time_edit] }
      specify{ expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with an opened DR" do
      let (:defreq) { FactoryGirl.create(:defence_request, :opened) }
      let (:actions) { group_actions + [:close, :feedback] }
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
    let(:user) { FactoryGirl.create(:cco_user)}
    let(:group_actions) { [:index, :refresh_dashboard, :dashboard_view] }

    context "with a created DR" do
      let (:defreq) { FactoryGirl.create(:defence_request) }
      let (:actions) { group_actions + [:open, :close, :feedback] }
      specify { expect(subject).to permit_actions_and_forbid_all_others actions }
    end

    context "with an opened DR" do
      let (:defreq) { FactoryGirl.create(:defence_request, :opened) }
      let (:actions) { group_actions + [:edit, :dscc_number_edit, :update, :close, :feedback] }
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

    [:index].each do |action|
      specify { expect(subject).to permit_action(action) }
    end

    describe "scope" do
      let (:defreq) { FactoryGirl.create(:defence_request) }
      # I expect we will return all the requests assigned to a solicitor in
      # the future, but for now we have no notion of such a thing.
      it "returns empty list" do
        expect(Pundit.policy_scope(user, DefenceRequest)).to eq []
      end
    end
  end

end
