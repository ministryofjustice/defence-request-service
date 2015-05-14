class AbortDefenceRequestsController < BaseController

  include DefenceRequestConcern
  before_action :find_defence_request
  before_action ->(c) { authorize_defence_request_access(:abort) }

  def new
    @abort_defence_request_form = AbortDefenceRequestForm.new(defence_request)
  end

  def create
    @abort_defence_request_form = AbortDefenceRequestForm.new(
      defence_request,
      transition,
      abort_defence_request_params
    )

    if @abort_defence_request_form.submit
      redirect_to dashboard_path("closed"), notice: flash_message(:abort, DefenceRequest)
    else
      render :new
    end
  end

  private

  def defence_request_id
    :defence_request_id
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
      transition_to: "abort",
      user: current_user,
      transition_info: abort_defence_request_params.fetch(:transition_info)
    }
  end
end
