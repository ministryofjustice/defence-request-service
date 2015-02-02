class DefenceRequestsController < BaseController

  def index
    @defence_requests = DefenceRequest.all
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

  def create
    @defence_request = DefenceRequest.new(defence_request_params)
    if @defence_request.save
      redirect_to({ action: :index }, notice: t('models.create', model: @defence_request.class))
    else
      render :new
    end
  end

  def edit
    @defence_request = DefenceRequest.find(params[:id])
  end

  def update
    @defence_request = DefenceRequest.find(params[:id])
    if @defence_request.update_attributes(defence_request_params)
      redirect_to({ action: :index }, notice: t('models.create', model: @defence_request.class))
    else
      render :edit
    end
  end

  def refresh_part
    @defence_requests = DefenceRequest.all

    respond_to do |format|
      format.js
    end
  end

  private

  def defence_request_params
    time_of_arrival = DateTime.parse(
      params[:defence_request]['time_of_arrival(1i)'] +
        sprintf('%02d', params[:defence_request]['time_of_arrival(2i)']) +
        sprintf('%02d', params[:defence_request]['time_of_arrival(3i)']) + ' ' +
        params[:defence_request]['time_of_arrival(4i)'] + ':' +
        params[:defence_request]['time_of_arrival(5i)']
    )

    params[:defence_request]['time_of_arrival'] = time_of_arrival

    params.require(:defence_request).permit(:solicitor_type,
                                          :solicitor_name,
                                          :solicitor_firm,
                                          :scheme,
                                          :phone_number,
                                          :detainee_surname,
                                          :detainee_first_name,
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



