require "rails_helper"

RSpec.describe DefenceRequestFactory, type: :model do
  describe ".build" do
    subject { described_class.build(current_user) }

    context "for CSO user" do
      let(:current_user) { create(:cso_user) }

      it "returns a DefenceRequest" do
        is_expected.to be_a(DefenceRequest)
      end

      it "returned DefenceRequest is not persisted" do
        is_expected.not_to be_persisted
      end

      it "has custody_suite_uid assigned" do
        expect(subject.custody_suite_uid).to eql(current_user.organisation["uid"])
      end
    end
  end
end