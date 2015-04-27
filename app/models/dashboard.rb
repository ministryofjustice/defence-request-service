class Dashboard
  def initialize(user, defence_requests_scoped_by_policy, additional_scopes)
    @user = user
    @defence_requests_scoped_by_policy = defence_requests_scoped_by_policy
    @additional_scopes = additional_scopes
  end

  def defence_requests
    additional_scopes.any? ? additional_scopes.map {|scope| ordered_defence_requests.send(scope) } : ordered_defence_requests
  end

  def user_role
    user.roles.uniq.first
  end

  private

  attr_reader :user, :defence_requests_scoped_by_policy, :additional_scopes

  def ordered_defence_requests
    defence_requests_scoped_by_policy.ordered_by_created_at
  end
end
