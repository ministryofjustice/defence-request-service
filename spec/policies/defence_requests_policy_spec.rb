require 'rails_helper'

RSpec.describe DefenceRequestPolicy do
  subject { DefenceRequestPolicy.new user, def_req }

  let (:def_req) { FactoryGirl.create(:defence_request) }

  context "Custody Suite Officers" do
    let(:user) { FactoryGirl.create(:cso_user) }

    [:index, :new, :create, :refresh_dashboard, :edit, :update, :dashboard_view].each do |action|
      specify { expect(subject).to permit_action(action) }
    end

    describe "scope" do
      it "returns all of the open requests" do
        expect(Pundit.policy_scope(user, DefenceRequest)).to eq [def_req]
      end
    end
  end

  context "Call Center Operatives" do
    let(:user) { FactoryGirl.create(:cco_user)}

    [:index, :refresh_dashboard, :dscc_number_edit, :open, :dashboard_view].each do |action|
      specify { expect(subject).to permit_action(action) }
    end

    describe "scope" do
      it "returns all of the open requests" do
        expect(Pundit.policy_scope(user, DefenceRequest)).to eq [def_req]
      end
    end
  end

  context "Solicitors" do
    let(:user) { FactoryGirl.create(:solicitor_user)}

    [:index].each do |action|
      specify { expect(subject).to permit_action(action) }
    end

    describe "scope" do
      # I expect we will return all the requests assigned to a solicitor in
      # the future, but for now we have no notion of such a thing.
      it "returns empty list" do
        expect(Pundit.policy_scope(user, DefenceRequest)).to eq []
      end
    end
  end

end
