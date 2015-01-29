class DefenceRequestsController < BaseController

  def index
  end

  def new
    @defence_request = DefenceRequest.new
    @solicitor = DefenceRequest.new
  end

  def solicitors_search
    query_string = params[:q]
    url = URI.parse "#{Settings.solicitor_search_domain}/solicitors/search/?q=#{query_string}"
    @solicitors = JSON.parse(HTTParty.post(url).body)['solicitors']
  end

end
