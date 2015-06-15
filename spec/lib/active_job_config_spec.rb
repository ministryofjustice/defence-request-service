require "spec_helper"
require "rails_helper"

require_relative "../../lib/active_job_config"

RSpec.describe ActiveJobConfig do
  describe "#name" do
    let(:queue_prefix) { "irrelevant_test_queue_prefix" }
    let(:queue_type) { "emails" }

    let(:queue_name) { "#{queue_prefix}_#{queue_type}_queue"}

    it "should return the correct queue name" do
      expect(Settings.rails).to receive(:active_job_queue_prefix).and_return(queue_prefix)

      expect(described_class.queue(queue_type)).to eq(queue_name)
    end
  end
end