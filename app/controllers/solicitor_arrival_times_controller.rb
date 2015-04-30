class SolicitorArrivalTimesController < BaseController

  include DefenceRequestAuthorization

  before_action :find_defence_request
  before_action :set_policy_with_context
  before_action :new_defence_request_form

  before_action ->(c) do
    policy = PolicyContext.new(defence_request, current_user)
    authorize policy, "solicitor_time_of_arrival?"
  end

  def edit
    render "defence_requests/solicitor_arrival_time"
  end

  def update
    if @defence_request_form.submit(defence_request_params)
      redirect_to(defence_request_path(@defence_request), notice: flash_message(:solicitor_time_of_arrival_added, DefenceRequest))
    else
      render "defence_requests/solicitor_arrival_time"
    end
  end

  private

  def defence_request_id
    params[:defence_request_id]
  end

  def defence_request_params
    params.require(:defence_request).permit(
      { solicitor_time_of_arrival: %i[day month year hour min sec] }
    )
  end
end
