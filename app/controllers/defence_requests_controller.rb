class DefenceRequestsController < BaseController

  include DefenceRequestConcern

  before_action :find_defence_request, except: [:new, :create]
  before_action :new_defence_request_form, only: [:show, :new, :create, :edit, :update]

  before_action ->(c) { authorize_defence_request_access(c.action_name) }

  helper_method :defence_request_path_with_tab

  def show
    @tab = params[:tab]
    if @defence_request.draft?
      render :show_draft
    else
      render :show
    end
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
    @part = params[:part]
    render edit_template
  end

  def update
    @part = params[:part]
    if @defence_request_form.submit(defence_request_params)
      redirect_to(defence_request_path_with_tab(@part), notice: flash_message(:update, DefenceRequest))
    else
      render edit_template
    end
  end

  def resend_details
    if @defence_request.resend_details
      redirect_to(dashboard_path, notice: flash_message(:details_sent, DefenceRequest))
    else
      redirect_to(dashboard_path, alert: flash_message(:failed_details_sent, DefenceRequest))
    end
  end

  private

  def defence_request_id
    :id
  end

  def defence_request_params
    params.require(:defence_request).permit(
      :solicitor_name,
      :solicitor_firm,
      :solicitor_email,
      { solicitor: :email },
      :scheme,
      :phone_number,
      :detainee_name,
      :gender,
      :adult,
      { date_of_birth: %i[day month year] },
      :appropriate_adult,
      :appropriate_adult_reason,
      :interpreter_required,
      :interpreter_type,
      :detainee_address,
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
      { interview_start_time: %i[date hour min] },
      { time_of_arrival: %i[date hour min] },
      { time_of_arrest: %i[date hour min] },
      { time_of_detention_authorised: %i[date hour min] },
      :dscc_number,
      :reason_aborted,
      { solicitor_time_of_arrival: %i[date hour min] },
      :detainee_name_not_given,
      :detainee_address_not_given,
      :date_of_birth_not_given)
  end

  def accept_and_save_defence_request
    @defence_request.accept && @defence_request.save
  end

  def edit_template
    if @defence_request.draft?
      :edit_draft
    else
      :edit
    end
  end

  def defence_request_path_with_tab(tab)
    if tab.present?
      defence_request_path(tab: tab)
    else
      defence_request_path
    end
  end
end
