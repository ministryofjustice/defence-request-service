class InterviewStartTimesController < BaseController

  include DefenceRequestConcern
  include AjaxEnabledConcern

  before_action :find_defence_request

  before_action ->(c) { authorize_defence_request_access(:interview_start_time_edit) }

  def edit
    @defence_request_form = DefenceRequestForm.new(defence_request)

    render_for_ajax_or_page(:_form, :edit)
  end

  def update
    @defence_request_form = DefenceRequestForm.new(defence_request, defence_request_params)

    if @defence_request_form.submit
      redirect_params = { notice: flash_message(:interview_start_time, DefenceRequest) }
      render_for_ajax_or_redirect(:_interview_time, defence_request_path(@defence_request), redirect_params)
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
