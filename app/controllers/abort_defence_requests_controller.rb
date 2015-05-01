class AbortDefenceRequestsController < BaseController
  def new
    authorize_aborting_defence_request

    @abort_defence_request_form = AbortDefenceRequestForm.new(defence_request)
  end

  def create
    authorize_aborting_defence_request

    @abort_defence_request_form = AbortDefenceRequestForm.new(
      defence_request,
      transition,
      abort_defence_request_params
    )

    if @abort_defence_request_form.submit
      redirect_to dashboard_path, notice: flash_message(:abort, DefenceRequest)
    else
      render :new
    end
  end

  private

  def authorize_aborting_defence_request
    authorize PolicyContext.new(defence_request, current_user), "#{requested_transition}?"
  end

  def requested_transition
    "abort"
  end

  def defence_request
    DefenceRequest.find(params.fetch(:defence_request_id))
  end

  def abort_defence_request_params
    params.require(:abort_defence_request_form).permit(:transition_info)
  end

  def transition
    DefenceRequestTransitions::Builder.new(transition_params).build
  end

  def transition_params
    {
      defence_request: defence_request,
      transition_to: requested_transition,
      user: current_user,
      transition_info: abort_defence_request_params.fetch(:transition_info)
    }
  end
end
