class TransitionDefenceRequestsController < BaseController
  def create
    authorize_transition

    if transition.complete
      redirect_to dashboard_path,
        notice: flash_message(requested_transition.to_sym, DefenceRequest)
    else
      redirect_to dashboard_path,
        notice: flash_message("failed_#{requested_transition}".to_sym, DefenceRequest)
    end
  end

  private

  def authorize_transition
    authorize PolicyContext.new(defence_request, current_user), "#{requested_transition}?"
  end

  def transition
    DefenceRequestTransitions::Builder.new(transition_params).build
  end

  def requested_transition
    params.fetch(:transition_to)
  end

  def defence_request
    DefenceRequest.find(params.fetch(:defence_request_id))
  end

  def transition_params
    {
      defence_request: defence_request,
      transition_to: requested_transition,
      user: current_user,
      auth_token: session[:user_token]
    }
  end
end
