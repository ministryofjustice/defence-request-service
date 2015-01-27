class DefenceRequestControllerPolicy < Struct.new(:user, :defense_request_controller)

  def index?
    user.cso?
  end

end