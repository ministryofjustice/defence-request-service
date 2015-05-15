class Dashboard
  def initialize(user, defence_requests_scoped_by_policy)
    @user = user
    @defence_requests_scoped_by_policy = defence_requests_scoped_by_policy
  end

  def set_visibility!(visibility)
    @visibility = visibility
  end

  def visible_requests
    case @visibility
      when :active
        active_defence_requests
      when :closed
        closed_defence_requests
      else
        active_defence_requests
    end
  end

  def defence_requests
    ordered_defence_requests
  end

  def user_role
    user.roles.uniq.first
  end

  def active_defence_requests
    @_active_defence_requests ||= defence_requests.select(&:active?)
  end

  def closed_defence_requests
    @_closed_defence_requests ||= defence_requests.select(&:closed?)
  end

  private

  attr_reader :user, :defence_requests_scoped_by_policy

  def ordered_defence_requests
    defence_requests_scoped_by_policy.ordered_by_created_at
  end

end
