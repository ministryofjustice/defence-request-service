require 'rails_helper'

RSpec.describe DefenceRequest, type: :model do
  describe 'validations' do

    it { expect(subject).to validate_presence_of :gender }
    it { expect(subject).to validate_presence_of :date_of_birth }
    it { expect(subject).to validate_presence_of :time_of_arrival }
    it { expect(subject).to validate_presence_of :custody_number }
    it { expect(subject).to validate_presence_of :detainee_name }
    it { expect(subject).to validate_presence_of :allegations }

    context 'own_solicitor' do
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
  end

  describe 'states' do
    it 'allows for correct transitions' do
      # state = created
      expect(subject.current_state).to eql :created
      expect(subject.can_transition? :open).to eq true
      expect(subject.can_transition? :close).to eq true
      expect(subject.can_transition? :created).to eq false
      expect(subject.can_transition? :finish).to eq false
      # state = open
      expect{ subject.open }.to_not raise_error
      expect(subject.current_state).to eql :opened
      expect(subject.can_transition? :open).to eq false
      expect(subject.can_transition? :close).to eq true
      expect(subject.can_transition? :created).to eq false
      expect(subject.can_transition? :finish).to eq true
      # state = closed
      expect{ subject.close }.to_not raise_error
      expect(subject.current_state).to eql :closed
      expect(subject.can_transition? :open).to eq false
      expect(subject.can_transition? :close).to eq false
      expect(subject.can_transition? :created).to eq false
      expect(subject.can_transition? :finish).to eq false
      # state = finished
      expect{ subject.finish }.to raise_error(Transitions::InvalidTransition)
      subject.update_current_state(:opened)
      expect{ subject.finish }.to_not raise_error
      expect(subject.current_state).to eql :finished
      expect(subject.can_transition? :open).to eq false
      expect(subject.can_transition? :close).to eq false
      expect(subject.can_transition? :created).to eq false
      expect(subject.can_transition? :finish).to eq false
    end
  end

  describe 'callbacks' do
    before do
      @persisted_request = FactoryGirl.create(:defence_request)
    end

    context 'interview time changes' do
      it 'notifies the solicitor'  do
        expect(@persisted_request).to receive(:notify_solicitor).and_call_original
        @persisted_request.update_attribute(:interview_start_time, Time.now)
      end
    end
    context 'save happens without change' do
      it 'does not notify the solicitor' do
        expect(@persisted_request).to_not receive(:notify_solicitor)
        @persisted_request.update_attribute(:detainee_name, "Eamonn Holmes")
      end
    end
  end
end
