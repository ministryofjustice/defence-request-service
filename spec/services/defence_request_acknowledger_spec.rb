require 'rails_helper'

RSpec.describe DefenceRequestAcknowledger do

  subject { DefenceRequestAcknowledger.new defence_request: defence_request }
  let(:defence_request) { create :defence_request, :queued }
  let(:cco)             { create :cco_user }

  describe "Retrying acknowledge" do
    context "One number is taken" do
      let!(:taken_number)     { 11111 }
      let!(:available_number) { 12124 }
      let!(:numbers)          { [taken_number, available_number].to_enum }
      let!(:existing_number)  { create :dscc_number, number: taken_number }

      specify "It will retry with a different number" do
        expect(Random).to receive(:rand).exactly(2).times { numbers.next }
        expect(subject.acknowledge_with cco: cco).to eq true
      end
    end

    context "All chosen numbers are taken" do
      let(:attempts_at_acknowledging)   { DefenceRequestAcknowledger::MAX_RETRIES + 1}
      let(:random_numbers)              { Array.new(attempts_at_acknowledging) { Random.rand(10**5-1) }.to_enum }
      let!(:existing_numbers)           { random_numbers.map { |n| create :dscc_number, number: n } }

      specify "it gives up after trying a few different numbers" do
        expect(Random).to receive(:rand).exactly(attempts_at_acknowledging).times { random_numbers.next }
        expect(subject.acknowledge_with cco: cco).to eq false
      end
    end
  end
end
