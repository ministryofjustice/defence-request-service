class DefenceRequestsController < BaseController

  before_action :find_defence_request, only: [:edit, :update, :close, :open]
  before_action ->(c) { authorize defence_request, "#{c.action_name}?" }

  def index
    @open_requests = policy_scope(DefenceRequest).opened.order(created_at: :asc)
    @new_requests = policy_scope(DefenceRequest).created.order(created_at: :asc)
  end

  def new
    @defence_request = DefenceRequest.new
    authorize @defence_request
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
      redirect_to(defence_requests_path, notice: flash_message(:create, DefenceRequest))
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @defence_request.update_attributes(defence_request_params)
      redirect_to(defence_requests_path, notice: flash_message(:update, DefenceRequest))
    else
      render :edit
    end
  end

  def refresh_dashboard
    @open_requests = policy_scope(DefenceRequest).opened.order(created_at: :asc)
    @new_requests = policy_scope(DefenceRequest).created.order(created_at: :asc)

    respond_to do |format|
      format.js
    end
  end

  def open
    @defence_request.open
    if @defence_request.save
      redirect_to(defence_requests_path, notice: flash_message(:open, DefenceRequest))
    else
      redirect_to(defence_requests_path, notice: flash_message(:failed_open, DefenceRequest))
    end
  end

  def close
    @defence_request.close
    if @defence_request.save
      redirect_to(defence_requests_path, notice: flash_message(:close, DefenceRequest))
    else
      redirect_to(defence_requests_path, notice: flash_message(:failed_close, DefenceRequest))
    end
  end

  private

  def find_defence_request
    @defence_request = DefenceRequest.find(params[:id])
  end

  def defence_request
    @defence_request ||= DefenceRequest.new
  end

  def defence_request_params
    params.require(:defence_request).permit(:solicitor_type,
                                            :solicitor_name,
                                            :solicitor_firm,
                                            :scheme,
                                            :phone_number,
                                            :detainee_name,
                                            :time_of_arrival,
                                            :gender,
                                            :adult,
                                            :date_of_birth,
                                            :appropriate_adult,
                                            :custody_number,
                                            :allegations,
                                            :comments,
                                            :time_of_arrival,
                                            :dscc_number)
  end

end

