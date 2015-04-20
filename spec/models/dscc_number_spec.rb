require 'rails_helper'

RSpec.describe DsccNumber, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "Retrying save" do

    subject { DsccNumber.new year_and_month: Time.now.beginning_of_month }

    context "One number is taken" do
      let!(:taken_number)     { 11111 }
      let!(:available_number) { 12124 }
      let!(:numbers)          { [taken_number, available_number].to_enum }
      let!(:existing_number)  { create :dscc_number, number: taken_number }

      specify "It will retry with a different number" do
        expect(Random).to receive(:rand).exactly(2).times { numbers.next }
        save_result = subject.save
        save_result.persisted? # <- This is returning true, despite the result being rolled back
      end
    end

    context "All chosen numbers are taken" do
      let(:attempts_at_saving)          { DsccNumber::MAX_RETRIES }
      let(:random_numbers)              { Array.new(attempts_at_saving) { Random.rand(10**5-1) }.to_enum }
      let!(:existing_numbers)           { random_numbers.map { |n| create :dscc_number, number: n } }

      specify "it gives up after trying a few different numbers" do
        expect(Random).to receive(:rand).exactly(attempts_at_saving).times { random_numbers.next }
        expect(subject.save).to eq false
      end
    end
  end
end
