class SolicitorArrivalTimesController < BaseController

  include DefenceRequestConcern

  before_action :find_defence_request
  before_action :new_defence_request_form

  before_action ->(c) { authorize_defence_request_access(:solicitor_time_of_arrival) }

  def edit
    render_edit_view
  end

  def update
    if @defence_request_form.submit(defence_request_params)
      redirect_to(defence_request_path(@defence_request), notice: flash_message(:solicitor_time_of_arrival_added, DefenceRequest))
    else
      render_edit_view
    end
  end

  private

  def defence_request_id
    :defence_request_id
  end

  def render_edit_view
    render "defence_requests/solicitor_arrival_time"
  end

  def defence_request_params
    params.require(:defence_request).permit(
      { solicitor_time_of_arrival: %i[day month year hour min sec] }
    )
  end
end
