class Dashboard
  def self.for(user, defence_requests_scoped_by_policy)
    new(user, defence_requests_scoped_by_policy)
  end

  def initialize(user, defence_requests_scoped_by_policy)
    @user = user
    @defence_requests_scoped_by_policy = defence_requests_scoped_by_policy
  end

  def to_partial_path
    "dashboards/#{user_role}_dashboard"
  end

  def defence_requests
    ordered_defence_requests
  end

  def user_role
    user.roles.uniq.first
  end

  private

  attr_reader :user, :defence_requests_scoped_by_policy

  def ordered_defence_requests
    defence_requests_scoped_by_policy.ordered_by_created_at
  end
end
