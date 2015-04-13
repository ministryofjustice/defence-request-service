require 'rails_helper'

RSpec.describe DefenceRequest, type: :model do
  describe 'validations' do

    it { expect(subject).to validate_presence_of :gender }
    it { expect(subject).to validate_presence_of :detainee_age }
    it { expect(subject).to validate_presence_of :custody_number }
    it { expect(subject).to validate_presence_of :detainee_name }
    it { expect(subject).to validate_presence_of :offences }
    it { expect(subject).to validate_numericality_of :detainee_age }

    context 'own solicitor' do
      before do
        subject.solicitor_type = "own"
      end
      it { expect(subject).to validate_presence_of :solicitor_name }
      it { expect(subject).to validate_presence_of :solicitor_firm }
      it { expect(subject).to validate_presence_of :phone_number }
      it { expect(subject).to_not validate_presence_of :scheme }
    end

    context 'duty solicitor' do
      before do
        subject.solicitor_type = "duty"
      end
      it { expect(subject).to validate_presence_of :scheme }
      it { expect(subject).to_not validate_presence_of :solicitor_name }
      it { expect(subject).to_not validate_presence_of :solicitor_firm }
      it { expect(subject).to_not validate_presence_of :phone_number }
    end

    context 'appropriate_adult_reason required' do
      before do
        subject.appropriate_adult = true
      end
      it { expect(subject).to validate_presence_of :appropriate_adult_reason }
    end

    context 'appropriate_adult_reason not required' do
      before do
        subject.appropriate_adult = false
      end
      it { expect(subject).to_not validate_presence_of :appropriate_adult_reason }
    end

    context 'unfit_for_interview_reason required' do
      before do
        subject.fit_for_interview = false
      end
      it { expect(subject).to validate_presence_of :unfit_for_interview_reason }
    end

    context 'unfit_for_interview_reason not required' do
      before do
        subject.fit_for_interview = true
      end
      it { expect(subject).to_not validate_presence_of :unfit_for_interview_reason }
    end
  end

  describe 'states' do

    it 'allows for correct transitions' do
      expect(DefenceRequest.available_states).to eq [:aborted, :accepted, :acknowledged, :draft, :finished, :queued]
      expect(DefenceRequest.available_events).to eq [:abort, :accept, :acknowledge, :finish, :queue]
    end

    shared_examples 'transition possible' do |event|
      specify { expect{ subject.send(event) }.to_not raise_error }
      specify { expect( subject.send("can_execute_#{event}?".to_sym) ).to eq true }
    end

    shared_examples 'transition impossible' do |event|
      specify { expect( subject.send("can_execute_#{event}?".to_sym) ).to eq false }
    end

    shared_examples 'allowed transitions' do |allowed_events|
      specify { expect(subject.current_state).to eql state }

      describe 'possible transitions' do
        allowed_events.each { |e| it_behaves_like 'transition possible', e }
      end

      describe 'impossible transitions' do
        disallowed_events = (DefenceRequest.available_events - allowed_events)
        disallowed_events.each { |e| it_behaves_like 'transition impossible', e }
      end
    end

    subject { FactoryGirl.create(:defence_request, state) }

    describe 'draft' do
      let(:state) { :draft }
      include_examples 'allowed transitions', [ :queue ]
    end

    describe 'queued' do
      let(:state) { :queued }
      include_examples 'allowed transitions', [ :acknowledge, :abort ]
    end

    describe 'acknowledged' do
      let(:state) { :acknowledged }
      include_examples 'allowed transitions', [ :finish, :abort ]

      context 'with dscc number' do
        subject { FactoryGirl.create(:defence_request, :acknowledged, :with_dscc_number) }
        include_examples 'allowed transitions', [ :accept, :finish, :abort ]
      end
    end

    describe 'accepted' do
      let(:state) { :accepted }
      include_examples 'allowed transitions', [ :finish, :abort ]
    end

    describe 'finished' do
      let(:state) { :finished }
      include_examples 'allowed transitions', []
    end
  end

  describe 'callbacks' do
    context 'marked as accepted' do
      before do
        @dr_with_dscc = FactoryGirl.create(:defence_request, :with_dscc_number, :acknowledged)
      end

      it 'notifies the solicitor'  do
        expect(@dr_with_dscc).to receive(:send_solicitor_case_details).and_call_original
        @dr_with_dscc.accept
      end
    end

    before do
      @persisted_request = FactoryGirl.create(:defence_request)
    end

    context 'interview time changes' do
      it 'notifies the solicitor'  do
        expect(@persisted_request).to receive(:notify_interview_start_change).and_call_original
        @persisted_request.update_attribute(:interview_start_time, DateTime.parse('13-04-1992 9:50'))
      end
    end

    context 'save happens without change' do
      it 'does not notify the solicitor' do
        expect(@persisted_request).to_not receive(:notify_interview_start_change)
        @persisted_request.update_attribute(:detainee_name, 'Eamonn Holmes')
      end
    end
  end
end
