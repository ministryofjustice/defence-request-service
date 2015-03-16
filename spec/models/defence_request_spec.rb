require 'rails_helper'

RSpec.describe DefenceRequest, type: :model do
  describe 'validations' do

    it { expect(subject).to validate_presence_of :gender }
    it { expect(subject).to validate_presence_of :detainee_age }
    it { expect(subject).to validate_presence_of :custody_number }
    it { expect(subject).to validate_presence_of :detainee_name }
    it { expect(subject).to validate_presence_of :allegations }
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
  end

  describe 'states' do
    it 'allows for correct transitions' do
      expect(DefenceRequest.available_states).to eq [:accepted, :closed, :draft, :finished, :opened, :queued]
    end

    describe 'draft' do
      subject { FactoryGirl.create(:defence_request, :draft) }

      specify { expect(subject.current_state).to eql :draft }

      describe 'possible transitions' do
        specify { expect{ subject.queue }.to_not raise_error }
        specify { expect(subject.can_execute_queue?).to eq true }
        specify { expect{ subject.close }.to_not raise_error }
        specify { expect(subject.can_execute_close?).to eq true }
      end

      describe 'impossible transitions' do
        specify { expect(subject.can_execute_open?).to eq false }
        specify { expect(subject.can_execute_accept?).to eq false }
        specify { expect(subject.can_execute_finish?).to eq false }
      end
    end

    describe 'opened' do
      subject { FactoryGirl.create(:defence_request, :opened) }

      specify { expect(subject.current_state).to eql :opened }

      context 'with dscc number' do
        subject { FactoryGirl.create(:defence_request, :opened, :with_dscc_number) }
        specify { expect{ subject.accept }.to_not raise_error }
        specify { expect(subject.can_execute_accept?).to eq true }
      end

      describe 'allowed transitions' do
        specify { expect{ subject.close }.to_not raise_error }
        specify { expect(subject.can_execute_close?).to eq true }
        specify { expect{ subject.finish }.to_not raise_error }
        specify { expect(subject.can_execute_finish?).to eq true }
      end

      describe 'disallowed transitions' do
        specify { expect(subject.can_execute_queue?).to eq false }
        specify { expect(subject.can_execute_open?).to eq false }
        specify { expect(subject.can_execute_accept?).to eq false }
      end
    end

    describe 'accepted' do
      subject { FactoryGirl.create(:defence_request, :accepted) }

      specify { expect(subject.current_state).to eql :accepted }

      describe 'possible transitions' do
        specify { expect{ subject.close }.to_not raise_error }
        specify { expect(subject.can_execute_close?).to eq true }
        specify { expect{ subject.finish }.to_not raise_error }
        specify { expect(subject.can_execute_finish?).to eq true }
      end

      describe 'impossible transitions' do
        specify { expect(subject.can_execute_queue?).to eq false }
        specify { expect(subject.can_execute_open?).to eq false }
        specify { expect(subject.can_execute_accept?).to eq false }
      end
    end

    describe 'closed' do
      subject { FactoryGirl.create(:defence_request, :closed) }

      specify { expect(subject.current_state).to eql :closed }

      describe 'impossible transitions' do
        specify { expect(subject.can_execute_queue?).to eq false }
        specify { expect(subject.can_execute_open?).to eq false }
        specify { expect(subject.can_execute_accept?).to eq false }
        specify { expect(subject.can_execute_close?).to eq false }
        specify { expect(subject.can_execute_finish?).to eq false }
      end
    end

    describe 'finished' do
      subject { FactoryGirl.create(:defence_request, :finished) }

      specify { expect(subject.current_state).to eql :finished }

      describe 'impossible transitions' do
        specify { expect(subject.can_execute_queue?).to eq false }
        specify { expect(subject.can_execute_open?).to eq false }
        specify { expect(subject.can_execute_accept?).to eq false }
        specify { expect(subject.can_execute_close?).to eq false }
        specify { expect(subject.can_execute_finish?).to eq false }
      end
    end
  end

  describe 'callbacks' do
    context 'marked as accepted' do
      before do
        @dr_with_dscc = FactoryGirl.create(:defence_request, :with_dscc_number, :opened)
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
