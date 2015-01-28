class DefenceRequestsController < BaseController

  def index
  end

  def new
    @defence_request = DefenceRequest.new
  end

end
