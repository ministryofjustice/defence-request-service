require "rails_helper"

RSpec.describe DefenceRequest, type: :model do
  describe "validations" do
    before { allow(subject).to receive(:detainee_name_not_given?).and_return(false) }

    it { expect(subject).to validate_presence_of :gender }
    it { expect(subject).to validate_presence_of :detainee_name }
    it { expect(subject).to validate_presence_of :offences }

    it { is_expected.to validate_presence_of(:appropriate_adult)}
    it { is_expected.to validate_presence_of(:fit_for_interview)}
    it { is_expected.to validate_presence_of(:interpreter_required)}

    context "appropriate_adult_reason required" do
      before do
        subject.appropriate_adult = true
      end
      it { expect(subject).to validate_presence_of :appropriate_adult_reason }

      context "with invalid reason value" do
        before do
          subject.appropriate_adult_reason = "bad value"
          subject.validate
        end
        it { expect(subject.errors[:appropriate_adult_reason].size).to eq(1) }
      end

      context "with detainee_juvenile value" do
        before do
          subject.appropriate_adult_reason = "detainee_juvenile"
          subject.validate
        end
        it { expect(subject.errors[:appropriate_adult_reason]).to be_blank }
      end
      context "with detainee_with_mental_issue value" do
        before do
          subject.appropriate_adult_reason = "detainee_with_mental_issue"
          subject.validate
        end
        it { expect(subject.errors[:appropriate_adult_reason]).to be_blank }
      end
    end

    context "appropriate_adult_reason not required" do
      before do
        subject.appropriate_adult = false
      end
      it { expect(subject).to_not validate_presence_of :appropriate_adult_reason }
    end

    context "unfit_for_interview_reason required" do
      before do
        subject.fit_for_interview = false
      end
      it { expect(subject).to validate_presence_of :unfit_for_interview_reason }
    end

    context "unfit_for_interview_reason not required" do
      before do
        subject.fit_for_interview = true
      end
      it { expect(subject).to_not validate_presence_of :unfit_for_interview_reason }
    end

    context "interpreter_type required" do
      before do
        subject.interpreter_required = true
      end
      it { expect(subject).to validate_presence_of :interpreter_type }
    end

    context "interpreter_type not required" do
      before do
        subject.interpreter_required = false
      end
      it { expect(subject).to_not validate_presence_of :interpreter_type }
    end
  end

  describe "states" do

    it "allows for correct transitions" do
      expect(DefenceRequest.available_states).to contain_exactly(:aborted, :accepted, :acknowledged, :draft, :completed, :queued)
      expect(DefenceRequest.available_events).to contain_exactly(:abort, :accept, :acknowledge, :complete, :queue)
    end

    shared_examples "transition possible" do |event|
      specify { expect{ subject.send(event) }.to_not raise_error }
      specify { expect(subject.send("can_execute_#{event}?".to_sym)).to eq true }
    end

    shared_examples "transition impossible" do |event|
      specify { expect(subject.send("can_execute_#{event}?".to_sym)).to eq false }
    end

    shared_examples "allowed transitions" do |allowed_events|
      specify { expect(subject.current_state).to eql state }

      describe "possible transitions" do
        allowed_events.each { |e| it_behaves_like "transition possible", e }
      end

      describe "impossible transitions" do
        disallowed_events = (DefenceRequest.available_events - allowed_events)
        disallowed_events.each { |e| it_behaves_like "transition impossible", e }
      end
    end

    subject { FactoryGirl.create(:defence_request, state) }

    describe "draft" do
      let(:state) { :draft }
      include_examples "allowed transitions", [ :queue ]
    end

    describe "queued" do
      let(:state) { :queued }
      include_examples "allowed transitions", [ :acknowledge, :abort ]
    end

    describe "acknowledged" do
      subject { FactoryGirl.create(:defence_request, :acknowledged) }

      let(:state) { :acknowledged }
      include_examples "allowed transitions", [:complete, :abort ]
    end

    describe "acknowledged with dscc_number" do
      subject { FactoryGirl.create(:defence_request, :acknowledged, :with_dscc_number) }

      let(:state) { :acknowledged }
      include_examples "allowed transitions", [ :accept, :complete, :abort ]
    end

    describe "accepted" do
      let(:state) { :accepted }
      include_examples "allowed transitions", [ :complete, :abort ]
    end

    describe "completed" do
      let(:state) { :completed }
      include_examples "allowed transitions", []
    end
  end

  describe "callbacks" do
    context "marked as accepted" do
      before do
        @dr_with_dscc = FactoryGirl.create(:defence_request, :with_dscc_number, :acknowledged)
      end

      it "notifies the solicitor"  do
        expect(@dr_with_dscc).to receive(:send_solicitor_case_details).and_call_original
        @dr_with_dscc.accept
      end
    end

    before do
      @persisted_request = FactoryGirl.create(:defence_request)
    end

    context "interview time changes" do
      it "notifies the solicitor"  do
        expect(@persisted_request).to receive(:notify_interview_start_change).and_call_original
        @persisted_request.update_attribute(:interview_start_time, DateTime.parse("13-04-1992 9:50"))
      end
    end

    context "save happens without change" do
      it "does not notify the solicitor" do
        expect(@persisted_request).to_not receive(:notify_interview_start_change)
        @persisted_request.update_attribute(:detainee_name, "Eamonn Holmes")
      end
    end
  end

  describe "retrieve requests associated with solicitor's firm" do
    let(:solicitor) { create(:solicitor_user) }
    let(:defence_requests) { DefenceRequest.related_to_solicitor(solicitor) }

    context "when associated requests exist" do
      it "returns requests" do
        firm_uid = solicitor.organisation_uids.first
        @defence_request = create(:defence_request, organisation_uid: firm_uid)
        expect(defence_requests).to eq([@defence_request])
      end
    end

    context "when no associated requests" do
      it "returns empty array" do
        expect(defence_requests).to eq([])
      end
    end
  end

end
