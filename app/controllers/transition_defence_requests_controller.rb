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
    authorize defence_request, "#{transition_params.fetch(:transition_to)}?"
  end

  def transition
    DefenceRequestTransition.new(defence_request, requested_transition, current_user)
  end

  def requested_transition
    transition_params.fetch(:transition_to)
  end

  def defence_request
    DefenceRequest.find(transition_params.fetch(:defence_request_id))
  end

  def transition_params
    params.permit(:defence_request_id, :transition_to)
  end
end
