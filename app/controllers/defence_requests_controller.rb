class DefenceRequestsController < BaseController

  before_action :find_defence_request, except: [:new, :create]
  before_action :set_policy_with_context, only: [:show, :new, :create, :edit, :update, :resend_details]
  before_action :new_defence_request_form, only: [:show, :new, :create, :edit, :update]

  before_action ->(c) { authorize PolicyContext.new(defence_request, current_user), "#{c.action_name}?" }

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
        redirect_to(dashboard_path, notice: flash_message(:updated_and_accepted, DefenceRequest))
      else
        redirect_to(edit_defence_request_path, alert: flash_message(:failed_to_update_not_accepted, DefenceRequest))
      end
    else
      if @defence_request_form.submit(defence_request_params)
        redirect_to(dashboard_path, notice: flash_message(:update, DefenceRequest))
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

  def update_and_accept?
    params[:commit] == "Update and Accept"
  end

  def find_defence_request
    @defence_request = DefenceRequest.find(params[:id])
  end

  def set_policy_with_context
    @policy ||= policy(PolicyContext.new(defence_request, current_user))
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
