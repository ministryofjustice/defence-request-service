module DefenceRequestAuthorization

  def find_defence_request
    @defence_request = DefenceRequest.find(defence_request_id)
  end

  def set_policy_with_context
    @policy ||= policy(PolicyContext.new(defence_request, current_user))
  end

  def defence_request
    @defence_request ||= DefenceRequest.new
  end

  def new_defence_request_form
    @defence_request_form ||= DefenceRequestForm.new(@defence_request)
  end

end
