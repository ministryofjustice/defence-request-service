require "rails_helper"
require_relative "../../app/models/dashboard"

RSpec.describe Dashboard, "#defence_requests" do
  it "returns the passed in defence requests ordered by created at" do
    user = double(:user)
    defence_requests = spy(:defence_requests)

    Dashboard.new(user, defence_requests, double).defence_requests

    expect(defence_requests).to have_received(:ordered_by_created_at)
  end
end

RSpec.describe Dashboard, "#user_role" do
  it "returns the first unique role for the given user" do
    user = double(:user, roles: ["admin", "cso", "cso", "cso"])
    defence_requests = double(:defence_requests)

    dashboard = Dashboard.new(user, defence_requests, double)

    expect(dashboard.user_role).to eq "admin"
  end
end
