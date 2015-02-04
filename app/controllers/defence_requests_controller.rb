class DefenceRequestsController < BaseController

  def index
    @defence_requests = DefenceRequest.order(created_at: :asc)
  end

  def new
    @defence_request = DefenceRequest.new
    @solicitor = DefenceRequest.new
  end

  def solicitors_search
    query_string = URI.escape(params[:q])
    search_url = URI.parse "#{Settings.dsds.solicitor_search_domain}/search/?q=#{query_string}"
    search_json = JSON.parse(HTTParty.post(search_url).body)

    # Below is evil, this is a quick hack to search for solicitors and firms in the same box until we figure out how
    # we should do it properly, probably with a proper search endpoint on the api using postgres full text search.
    solicitors = search_json['solicitors'].map { |s| s.tap { |t| t['firm_name'] = t['firm']['name']; t.delete 'firm'} }
    firm_solicitors = search_json['firms'].map {|f| f['solicitors'].map { |s| s.tap { |t| t['firm_name'] = f['name'] } } }.flatten
    @solicitors = (firm_solicitors + solicitors).uniq
  end

  def create
    @defence_request = DefenceRequest.new(defence_request_params)
    if @defence_request.save
      redirect_to({ action: :index }, notice: t('models.create', model: @defence_request.class))
    else
      render :new
    end
  end

  def refresh_dashboard
    @defence_requests = DefenceRequest.order(created_at: :asc)

    respond_to do |format|
      format.js
    end
  end

  private

  def defence_request_params
    params.require(:defence_request).permit(:solicitor_type,
                                          :solicitor_name,
                                          :solicitor_firm,
                                          :scheme,
                                          :phone_number,
                                          :detainee_surname,
                                          :detainee_first_name,
                                          :time_of_arrival,
                                          :gender,
                                          :adult,
                                          :date_of_birth,
                                          :appropriate_adult,
                                          :custody_number,
                                          :allegations,
                                          :comments,
                                          :time_of_arrival)
  end
end



