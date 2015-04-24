class FinishDefenceRequestsController < BaseController
  def new
    authorize_finishing_defence_request

    @finish_defence_request_form = FinishDefenceRequestForm.new(defence_request)
  end

  def create
    authorize_finishing_defence_request

    @finish_defence_request_form = FinishDefenceRequestForm.new(
      defence_request,
      transition,
      finish_defence_request_params
    )

    if @finish_defence_request_form.submit
      redirect_to dashboard_path, notice: "All good"
    else
      render :new
    end
  end

  private

  def authorize_finishing_defence_request
    authorize defence_request, "#{requested_transition}?"
  end

  def requested_transition
    params.fetch(:transition_to)
  end

  def defence_request
    DefenceRequest.find(params.fetch(:defence_request_id))
  end

  def finish_defence_request_params
    params.require(:finish_defence_request_form).permit(:transition_info)
  end

  def transition
    DefenceRequestTransitions::Builder.new(transition_params).build
  end

  def transition_params
    {
      defence_request: defence_request,
      transition_to: requested_transition,
      user: current_user,
      transition_info: finish_defence_request_params.fetch(:transition_info)
    }
  end
end
