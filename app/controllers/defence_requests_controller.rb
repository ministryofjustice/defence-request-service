class DefenceRequestsController < BaseController

  include DefenceRequestConcern

  before_action :find_defence_request, except: [:new, :create]
  before_action :new_defence_request_form, only: [:show, :new, :create, :edit, :update]

  before_action ->(c) { authorize_defence_request_access(c.action_name) }

  def show
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
    if @defence_request.draft?
      @part = params[:part]
      render :edit_draft
    else
      render :edit
    end
  end

  def update
    if update_and_accept?
      if @defence_request_form.submit(defence_request_params) && accept_and_save_defence_request
        redirect_to(dashboard_path, notice: flash_message(:updated_and_accepted, DefenceRequest))
      else
        redirect_to(edit_defence_request_path, alert: flash_message(:failed_to_update_not_accepted, DefenceRequest))
      end
    else
      if @defence_request_form.submit(defence_request_params)
        redirect_to(defence_request_path, notice: flash_message(:update, DefenceRequest))
      else
        render :edit
      end
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

  def update_and_accept?
    params[:commit] == "Update and Accept"
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
end
