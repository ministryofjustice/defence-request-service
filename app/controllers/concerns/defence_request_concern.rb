module DefenceRequestConcern

  private

  def find_defence_request
    @defence_request = DefenceRequestPresenter.new client, DefenceRequest.find(params[defence_request_id])
  end

  def defence_request
    @defence_request ||= DefenceRequestFactory.build(current_user)
  end

  def authorize_defence_request_access(action, request_to_authorize = defence_request)
    policy_context = PolicyContext.new(request_to_authorize, current_user)
    @policy ||= policy(policy_context)
    authorize policy_context, "#{action}?"
  end

end
