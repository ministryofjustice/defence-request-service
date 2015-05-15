class InterviewStartTimeDefenceRequestsController < BaseController

  include DefenceRequestConcern

  before_action :find_defence_request
  before_action :new_defence_request_form

  before_action ->(c) { authorize_defence_request_access(:interview_start_time_edit) }

  def new
  end

  def create
    if @defence_request_form.submit(interview_start_time_defence_request_params)
      redirect_to(defence_request_path(@defence_request), notice: flash_message(:interview_start_time, DefenceRequest))
    else
      render :new
    end
  end

  private

  def defence_request_id
    :defence_request_id
  end

  def interview_start_time_defence_request_params
    params.require(:defence_request).permit(
      { interview_start_time: %i[day month year hour min sec] }
    )
  end
end
