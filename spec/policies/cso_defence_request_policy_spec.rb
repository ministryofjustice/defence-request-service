require "rails_helper"

RSpec.describe CsoDefenceRequestPolicy do
  let(:user) { create :cso_user }
  let(:custody_suite_uid) { user.organisation["uid"] }
  let(:context) { PolicyContext.new defence_request, user }

  subject { CsoDefenceRequestPolicy.new(user, context) }

  context "with request not assigned to the same custody suite" do
    let(:defence_request) { build(:defence_request) }
    let(:allowed_actions) { [:new] }

    it { is_expected.to permit_actions_and_forbid_all_others(allowed_actions) }
  end

  context "with request assigned to the same custody suite" do
    context "with aborted request" do
      let(:defence_request) { build(:defence_request, :aborted, custody_suite_uid: custody_suite_uid)}
      let(:allowed_actions) { [:new, :create] }

      it { is_expected.to permit_actions_and_forbid_all_others(allowed_actions) }
    end

    context "with not aborted request" do
      context "with draft request" do
        let(:defence_request) { build(:defence_request, :draft, custody_suite_uid: custody_suite_uid)}
        let(:allowed_actions) { [:show, :new, :create, :edit, :update, :interview_start_time_edit, :queue] }

        it { is_expected.to permit_actions_and_forbid_all_others(allowed_actions) }
      end

      %i(queued acknowledged accepted).each do |state|
        context "with #{state} request" do
          let(:defence_request) { build(:defence_request, state, custody_suite_uid: custody_suite_uid)}
          let(:allowed_actions) { [:show, :new, :create, :edit, :update, :interview_start_time_edit] }

          it { is_expected.to permit_actions_and_forbid_all_others(allowed_actions) }
        end
      end
    end
  end
end
