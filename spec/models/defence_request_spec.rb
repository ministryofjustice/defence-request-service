require 'rails_helper'

RSpec.describe DefenceRequest, type: :model do
  describe 'states' do

    it { expect(subject).to validate_presence_of :gender }
    it { expect(subject).to validate_presence_of :date_of_birth }
    it { expect(subject).to validate_presence_of :time_of_arrival }
    it { expect(subject).to validate_presence_of :custody_number }

    it { expect(subject).to ensure_length_of(:detainee_surname).is_at_least(2) }
    it { expect(subject).to ensure_length_of(:detainee_first_name).is_at_least(2) }
    it { expect(subject).to ensure_length_of(:allegations).is_at_least(2) }

    it { expect(subject).to allow_value('020 1234 5678', '+44(0)7891234567').for(:phone_number) }
    it { expect(subject).to_not allow_value('1234', 'ABC').for(:phone_number) }
  end

  describe 'states' do
    specify { expect(subject.state).to eql 'open' }

    specify { expect{ subject.close }.to_not raise_error }
    specify { expect{ subject.close; subject.close }.to raise_error(SimpleStates::TransitionException) }
  end
end
