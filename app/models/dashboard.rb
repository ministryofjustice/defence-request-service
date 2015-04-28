class Dashboard
  def initialize(user, defence_requests_scoped_by_policy, additional_scopes = nil)
    @user = user
    @defence_requests_scoped_by_policy = defence_requests_scoped_by_policy
    @additional_scopes = additional_scopes
  end

  def defence_requests
    additional_scopes.blank? ? ordered_defence_requests : scoped_defence_requests(additional_scopes)
  end

  def user_role
    user.roles.uniq.first
  end

  private

  attr_reader :user, :defence_requests_scoped_by_policy, :additional_scopes

  def scoped_defence_requests(scopes)
    scopes.map { |scope| ordered_defence_requests.send(scope) }.flatten
  end

  def ordered_defence_requests
    defence_requests_scoped_by_policy.ordered_by_created_at
  end
end
