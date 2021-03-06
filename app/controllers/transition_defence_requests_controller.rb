class TransitionDefenceRequestsController < BaseController

  include DefenceRequestConcern

  def create
    find_defence_request
    authorize_defence_request_access(requested_transition)

    if transition.complete
      redirect_to custody_suite_dashboard_path,
        notice: flash_message(requested_transition.to_sym, DefenceRequest)
    else
      redirect_to custody_suite_dashboard_path,
        notice: flash_message("failed_#{requested_transition}".to_sym, DefenceRequest)
    end
  end

  private

  def defence_request_id
    :defence_request_id
  end

  def transition
    DefenceRequestTransitions::Builder.new(transition_params).build
  end

  def requested_transition
    params.fetch(:transition_to)
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
