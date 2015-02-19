class DefenceRequestsController < BaseController

  before_action :find_defence_request, only: [:edit, :update, :feedback, :close, :open, :accepted, :resend_details]
  before_action ->(c) { authorize defence_request, "#{c.action_name}?" }

  def index
    @open_requests = policy_scope(DefenceRequest).opened.order(created_at: :asc)
    @created_requests = policy_scope(DefenceRequest).created.order(created_at: :asc)
    @accepted_requests = policy_scope(DefenceRequest).accepted.order(created_at: :asc)
  end

  def show
    @defence_request = policy_scope(DefenceRequest).find(params[:id])
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
    if update_and_accept?
      update_and_accept
    else
      if @defence_request.update_attributes(defence_request_params)
        redirect_to(defence_requests_path, notice: flash_message(:update, DefenceRequest))
      else
        render :edit
      end
    end
  end

  def refresh_dashboard
    @open_requests = policy_scope(DefenceRequest).opened.order(created_at: :asc)
    @created_requests = policy_scope(DefenceRequest).created.order(created_at: :asc)
    @accepted_requests = policy_scope(DefenceRequest).accepted.order(created_at: :asc)

    respond_to do |format|
      format.js
    end
  end

  def open
    @defence_request.open
    associate_cco
    if @defence_request.save
      redirect_to(defence_requests_path, notice: flash_message(:open, DefenceRequest))
    else
      redirect_to(defence_requests_path, notice: flash_message(:failed_open, DefenceRequest))
    end
  end

  def feedback
    if @defence_request.update_attributes(defence_request_params) && close_and_save_defence_request
      redirect_to(defence_requests_path, notice: flash_message(:close, DefenceRequest))
    else
      render :close
    end
  end

  def close
  end

  def accepted
    @defence_request.accept
    if @defence_request.save
      redirect_to(defence_requests_path, notice: flash_message(:accepted, DefenceRequest))
    else
      redirect_to(defence_requests_path, notice: flash_message(:failed_accepted, DefenceRequest))
    end
  end

  def resend_details
    if @defence_request.resend_details
      redirect_to(defence_requests_path, notice: flash_message(:details_sent, DefenceRequest))
    else
      redirect_to(defence_requests_path, notice: flash_message(:failed_details_sent, DefenceRequest))
    end
  end

  private

  def associate_cco
    @defence_request.cco = current_user
  end

  def update_and_accept?
    params[:commit] == 'Update and Accept'
  end

  def update_and_accept
    case
      when solicitor_details_missing?
        redirect_to(edit_defence_request_path, alert: flash_message(:solicitor_details_required, DefenceRequest))
      when dscc_number_missing?
        redirect_to(edit_defence_request_path, alert: flash_message(:dscc_number_required, DefenceRequest))
      when @defence_request.update_attributes(defence_request_params) && accepted_and_save_defence_request
        redirect_to(defence_requests_path, notice: flash_message(:updated_and_updated, DefenceRequest))
    end
  end

  def solicitor_details_missing?
     defence_request_params[:solicitor_name].blank? || defence_request_params[:solicitor_firm].blank?
  end

  def dscc_number_missing?
    defence_request_params[:dscc_number].blank?
  end

  def find_defence_request
    @defence_request = DefenceRequest.find(params[:id])
  end

  def defence_request
    @defence_request ||= DefenceRequest.new
  end

  def defence_request_params
    raw_params = params.require(:defence_request).permit(:solicitor_type,
                                                         :solicitor_name,
                                                         :solicitor_firm,
                                                         :solicitor_email,
                                                         :scheme,
                                                         :phone_number,
                                                         :detainee_name,
                                                         :detainee_age,
                                                         :time_of_arrival,
                                                         :gender,
                                                         :adult,
                                                         :date_of_birth_day,
                                                         :date_of_birth_month,
                                                         :date_of_birth_year,
                                                         :appropriate_adult,
                                                         :custody_number,
                                                         :allegations,
                                                         :comments,
                                                         :interview_start_time_hour,
                                                         :interview_start_time_minute,
                                                         :time_of_arrival_hour,
                                                         :time_of_arrival_minute,
                                                         :dscc_number,
                                                         :feedback)
    raw_params.tap do |p|
      email = p.delete("solicitor_email")
      solicitor = User.solicitors.find_by_email email
      p["solicitor_id"] = solicitor.id if solicitor

      year = p.delete('date_of_birth_year')
      month = p.delete('date_of_birth_month')
      day = p.delete('date_of_birth_day')
      if !(day.blank? || month.blank? && year.blank?)
        p["date_of_birth"] = DateTime.new year.to_i, month.to_i, day.to_i
      end

      current_year = DateTime.now.year
      current_month = DateTime.now.month
      current_day = DateTime.now.day

      arrival_hour = p.delete('time_of_arrival_hour')
      arrival_minute = p.delete('time_of_arrival_minute')
      if arrival_hour && arrival_minute
        p['time_of_arrival'] = DateTime.new current_year, current_month, current_day, arrival_hour.to_i, arrival_minute.to_i
      end

      interview_hour = p.delete('interview_start_time_hour')
      interview_minute = p.delete('interview_start_time_minute')
      if interview_hour && interview_minute
        p['interview_start_time'] = DateTime.new current_year, current_month, current_day, interview_hour.to_i, interview_minute.to_i
      end


      appropriate_adult = p.delete 'appropriate_adult'
      if appropriate_adult
        p['appropriate_adult'] = appropriate_adult == 'yes'
      end

    end
  end

  def close_and_save_defence_request
    @defence_request.close && @defence_request.save
  end

  def accepted_and_save_defence_request
    @defence_request.accept && @defence_request.save
  end
end

