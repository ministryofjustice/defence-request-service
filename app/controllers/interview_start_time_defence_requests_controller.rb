class InterviewStartTimeDefenceRequestsController < BaseController
  skip_after_action :verify_authorized
  before_action :set_policy_with_context, :find_defence_request

  def new
    @defence_request_form ||= DefenceRequestForm.new @defence_request
  end

  def create
    @defence_request_form ||= DefenceRequestForm.new @defence_request

    if @defence_request_form.submit(interview_start_time_defence_request_params)
      redirect_to(defence_request_path(@defence_request), notice: flash_message(:interview_start_time, DefenceRequest))
    else
      render :new
    end
  end

  private

  def policy_context
    @_policy_context ||= PolicyContext.new(DefenceRequest, current_user)
  end

  def set_policy_with_context
    @policy ||= policy(policy_context)
  end

  def find_defence_request
    @defence_request ||= DefenceRequest.find(params.fetch(:defence_request_id))
  end

  def interview_start_time_defence_request_params
    params.require(:defence_request).permit({interview_start_time: %i[day month year hour min sec]})
  end
end
