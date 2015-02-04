class DefenceRequestsControllerPolicy < Struct.new(:user, :defense_request_controller)
  def index?
    user.cso? || user.cco?
  end

  def new?
    user.cso?
  end

  def create?
    user.cso?
  end

  def edit?
    user.cso?
  end

  def update?
    user.cso?
  end

  def solicitors_search?
    user.cso?
  end

  def refresh_dashboard?
    user.cso? || user.cco?
  end

end
