module DefenceRequestConcern

  private

  def find_defence_request
    @defence_request = DefenceRequest.find(params[defence_request_id])
  end

  def defence_request
    @defence_request ||= DefenceRequest.new
  end

  def new_defence_request_form
    @defence_request_form ||= DefenceRequestForm.new(defence_request)
  end

  def authorize_defence_request_access action
    policy_context = PolicyContext.new(defence_request, current_user)
    @policy ||= policy(policy_context)
    authorize policy_context, "#{action}?"
  end

end
