class InterviewStartTimesController < BaseController

  include DefenceRequestConcern
  include AjaxEnabledConcern

  before_action :find_defence_request
  before_action :new_defence_request_form

  before_action ->(c) { authorize_defence_request_access(:interview_start_time_edit) }

  def edit
    render_for_ajax_or_page(:_form, :edit)
  end

  def update
    if @defence_request_form.submit(defence_request_params)
      render_for_ajax_or_redirect(:_interview_time, defence_request_path(@defence_request), notice: flash_message(:interview_start_time, DefenceRequest))
    else
      render_for_ajax_or_page(:_form, :edit)
    end
  end

  private

  def defence_request_id
    :defence_request_id
  end

  def defence_request_params
    params.require(:defence_request).permit(
      { interview_start_time: %i[date hour min] }
    )
  end
end
