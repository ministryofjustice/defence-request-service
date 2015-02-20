require 'rails_helper'

RSpec.describe AddSolicitorTimeOfArrival do

  let(:defence_request) { instance_double('DefenceRequest') }
  let(:date_time) { Time.current }

  describe 'passing valid parameters' do

    it 'is successful' do
      expect(defence_request).to receive(:update_attributes).with(date_time)
      AddSolicitorTimeOfArrival.new(defence_request, date_time).call
    end
  end
end
