class Dashboard
  def initialize(user, defence_requests_scoped_by_policy)
    @user = user
    @defence_requests_scoped_by_policy = defence_requests_scoped_by_policy
  end

  def user_role
    user.roles.uniq.first
  end

  def defence_requests(type)
    type == :active ? active_defence_requests : closed_defence_requests
  end

  private

  attr_reader :user, :defence_requests_scoped_by_policy

  def active_defence_requests
    if user_role == "solicitor"
      scoped_defence_requests([:not_finished])
    else
      ordered_defence_requests
    end
  end

  def closed_defence_requests
    scoped_defence_requests([:finished, :aborted])
  end

  def scoped_defence_requests(scopes)
    scopes.map { |scope| ordered_defence_requests.send(scope) }.flatten
  end

  def ordered_defence_requests
    defence_requests_scoped_by_policy.ordered_by_created_at
  end
end
