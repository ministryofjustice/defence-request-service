require "rails_helper"
require_relative "../../app/models/dashboard"

RSpec.describe Dashboard, "#defence_requests" do
  context "active" do
    context "solicitor" do
      it "returns the not_finished passed defence requests ordered by created at" do
        user = double(:user, roles: ["solicitor"])
        defence_requests = spy(:defence_requests)

        Dashboard.new(user, defence_requests).defence_requests(:active)

        expect(defence_requests).to have_received(:ordered_by_created_at)
        expect(defence_requests).to have_received(:not_finished)
      end
    end

    context "non solicitor" do
      it "returns the active passed defence requests ordered by created at" do
        user = double(:user, roles: ["solicitor"])
        defence_requests = spy(:defence_requests)

        Dashboard.new(user, defence_requests).defence_requests(:active)

        expect(defence_requests).to have_received(:ordered_by_created_at)
      end
    end
  end

  context "closed" do
    it "returns the closed passed defence requests ordered by created at" do
      user = double(:user)
      defence_requests = spy(:defence_requests)

      Dashboard.new(user, defence_requests).defence_requests(:closed)

      expect(defence_requests).to have_received(:ordered_by_created_at).twice
      expect(defence_requests).to have_received(:finished)
      expect(defence_requests).to have_received(:aborted)
    end
  end
end

RSpec.describe Dashboard, "#user_role" do
  it "returns the first unique role for the given user" do
    user = double(:user, roles: ["admin", "cso", "cso", "cso"])
    defence_requests = double(:defence_requests)

    dashboard = Dashboard.new(user, defence_requests)

    expect(dashboard.user_role).to eq "admin"
  end
end
