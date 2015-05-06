require "spec_helper"
require_relative "../../lib/service_registry"

RSpec.describe ServiceRegistry do

  subject(:registry) { described_class }
  let(:service) { double }

  before do
    registry.register(:existing, service)
  end

  describe ".register" do
    it "stores the given service" do
      described_class.register(:new, service)

      expect(described_class.services).to include(:new => service)
    end
  end

  describe ".service" do
    context "when service is registered" do
      it "returns the service" do
        expect(registry.service(:existing)).to be(service)
      end
    end

    context "when service is not registered" do
      it "raises ServiceNotRegistered exception" do
        expect { registry.service(:non_existent) }.to raise_error(ServiceRegistry::ServiceNotRegistered)
      end
    end
  end
end
