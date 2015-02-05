require 'rails_helper'

RSpec.describe DefenceRequest, type: :model do
  describe 'states' do

    it { expect(subject).to validate_presence_of :gender }
    it { expect(subject).to validate_presence_of :date_of_birth }
    it { expect(subject).to validate_presence_of :time_of_arrival }
    it { expect(subject).to validate_presence_of :custody_number }
    it { expect(subject).to validate_presence_of :phone_number }
    it { expect(subject).to validate_presence_of :solicitor_name }
    it { expect(subject).to validate_presence_of :solicitor_firm }
    it { expect(subject).to validate_presence_of :detainee_name }
    it { expect(subject).to validate_presence_of :allegations }
  end

  describe 'states' do
    specify { expect(subject.state).to eql 'open' }

    specify { expect{ subject.close }.to_not raise_error }
    specify { expect{ subject.close; subject.close }.to raise_error(SimpleStates::TransitionException) }
  end
end
