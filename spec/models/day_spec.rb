require "spec_helper"
require_relative "../../app/models/day.rb"

RSpec.describe Day do
  subject { Day::TODAY }

  describe ".date" do
    it "calculates dates dynamically"  do
      current_day = Date.today
      the_end_of_days = Date::Infinity

      allow(Date).to receive(:today).and_return current_day, the_end_of_days

      expect(subject.date).to eq current_day
      expect(subject.date).to eq the_end_of_days
    end
  end
end
