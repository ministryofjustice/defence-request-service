class DefenceRequestsController < BaseController

  before_action :find_defence_request, except: [:index, :new, :create, :refresh_dashboard, :solicitors_search]
  before_action :set_policy, except: [:index, :refresh_dashboard, :solicitors_search]
  before_action :new_defence_request_form, only: [:show, :new, :create, :edit, :update, :solicitor_time_of_arrival]
  before_action :get_defence_request_scopes, only: [:index, :refresh_dashboard]

  before_action ->(c) { authorize defence_request, "#{c.action_name}?" }

  def index
  end

  def show
  end

  def new
  end

  def create
    if @defence_request_form.submit(defence_request_params)
      redirect_to(@defence_request_form.defence_request, notice: flash_message(:create, DefenceRequestForm))
    else
      render :new
    end
  end

  def edit
  end

  def update
    if update_and_accept?
      if @defence_request_form.submit(defence_request_params) && accept_and_save_defence_request
        redirect_to(defence_requests_path, notice: flash_message(:updated_and_accepted, DefenceRequest))
      else
        redirect_to(edit_defence_request_path, alert: flash_message(:failed_to_update_not_accepted, DefenceRequest))
      end
    else
      if @defence_request_form.submit(defence_request_params)
        redirect_to(defence_requests_path, notice: flash_message(:update, DefenceRequest))
      else
        render :edit
      end
    end
  end

  def solicitors_search
    query_string = URI.escape(params[:q])
    search_url = URI.parse "#{Settings.dsds.solicitor_search_url_prefix}/search/?q=#{query_string}"
    search_json = JSON.parse(HTTParty.post(search_url).body)

    # Below is evil, this is a quick hack to search for solicitors and firms in the same box until we figure out how
    # we should do it properly, probably with a proper search endpoint on the api using postgres full text search.
    solicitors = search_json['solicitors'].map { |s| s.tap { |t| t['firm_name'] = t['firm']['name']; t.delete 'firm'} }
    firm_solicitors = search_json['firms'].map {|f| f['solicitors'].map { |s| s.tap { |t| t['firm_name'] = f['name'] } } }.flatten
    @solicitors = (firm_solicitors + solicitors).uniq
  end

  def refresh_dashboard
    respond_to do |format|
      format.js
    end
  end

  def acknowledge
    if @defence_request.acknowledge && associate_cco && @defence_request.save
      redirect_to(defence_requests_path, notice: flash_message(:acknowledged, DefenceRequest))
    else
      redirect_to(defence_requests_path, alert: flash_message(:failed_acknowledge, DefenceRequest))
    end
  end

  def abort
  end

  def reason_aborted
    @defence_request.reason_aborted = defence_request_params[:reason_aborted]

    if @defence_request.abort && @defence_request.save
      redirect_to defence_requests_path, notice: flash_message(:aborted, DefenceRequest)
    else
      render :abort
    end
  end

  def accept
    if @defence_request.accept && @defence_request.save
      redirect_to(defence_requests_path, notice: flash_message(:accept, DefenceRequest))
    else
      redirect_to(defence_requests_path, alert: flash_message(:failed_accept, DefenceRequest))
    end
  end

  def resend_details
    if @defence_request.resend_details
      redirect_to(defence_requests_path, notice: flash_message(:details_sent, DefenceRequest))
    else
      redirect_to(defence_requests_path, alert: flash_message(:failed_details_sent, DefenceRequest))
    end
  end

  def solicitor_time_of_arrival
    if @defence_request_form.submit(defence_request_params)
      redirect_to(defence_request_path(@defence_request), notice: flash_message(:solicitor_time_of_arrival_added, DefenceRequest))
    else
      render :show
    end
  end

  def queue
    if @defence_request.queue && @defence_request.save
      redirect_to(defence_requests_path, notice: flash_message(:sent_for_processing, DefenceRequest))
    else
      redirect_to(defence_requests_path, alert: flash_message(:failed_send_for_processing, DefenceRequest))
    end
  end

  private

  def get_defence_request_scopes
    @draft_requests = policy_scope(DefenceRequest).draft.order(created_at: :asc)
    @queued_requests = policy_scope(DefenceRequest).queued.order(created_at: :asc)
    @acknowledged_requests = policy_scope(DefenceRequest).acknowledged.order(created_at: :asc)
    @accepted_requests = policy_scope(DefenceRequest).accepted.order(created_at: :asc)
    @aborted_requests = policy_scope(DefenceRequest).aborted.order(created_at: :asc)
  end

  def associate_cco
    @defence_request.cco = current_user
  end

  def update_and_accept?
    params[:commit] == 'Update and Accept'
  end

  def solicitor_details_missing?
    !@defence_request.solicitor && (defence_request_params[:solicitor_name].blank? || defence_request_params[:solicitor_firm].blank?)
  end

  def dscc_number_missing?
    defence_request_params[:dscc_number].blank?
  end

  def find_defence_request
    @defence_request = DefenceRequest.find(params[:id])
  end

  def set_policy
    @policy ||= policy(defence_request)
  end

  def defence_request
    @defence_request ||= DefenceRequest.new
  end

  def new_defence_request_form
    @defence_request_form ||= DefenceRequestForm.new @defence_request
  end

  def defence_request_params
    params.require(:defence_request).permit(
      :solicitor_type,
      :solicitor_name,
      :solicitor_firm,
      :solicitor_email,
      { solicitor: :email },
      :scheme,
      :phone_number,
      :detainee_name,
      :detainee_age,
      :gender,
      :adult,
      { date_of_birth: %i[day month year] },
      :appropriate_adult,
      :appropriate_adult_reason,
      :interpreter_required,
      :interpreter_type,
      :house_name,
      :address_1,
      :address_2,
      :city,
      :county,
      :postcode,
      :custody_number,
      :offences,
      :circumstances_of_arrest,
      :fit_for_interview,
      :unfit_for_interview_reason,
      :custody_address,
      :investigating_officer_name,
      :investigating_officer_shoulder_number,
      :investigating_officer_contact_number,
      :comments,
      { interview_start_time: %i[day month year hour min sec] },
      { time_of_arrival: %i[day month year hour min sec] },
      { time_of_arrest: %i[day month year hour min sec] },
      { time_of_detention_authorised: %i[day month year hour min sec] },
      :dscc_number,
      :reason_aborted,
      { solicitor_time_of_arrival: %i[day month year hour min sec] })
  end

  def accept_and_save_defence_request
    @defence_request.accept && @defence_request.save
  end
end
