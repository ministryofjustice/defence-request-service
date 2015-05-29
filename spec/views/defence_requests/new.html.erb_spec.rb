require "rails_helper"

RSpec.describe "defence_requests/new.html.erb" do

  def assert_disable_set(input_id, check_id)
    expect(rendered).to have_css("//input[@id='#{ input_id }'][@data-disable-when='#{ check_id }']")
    expect(rendered).to have_css("//input[@id='#{ check_id }']")
  end

  def assert_show_hide_set(element_type, check_id)
    expect(rendered).to have_css("//#{ element_type }[@data-show-when='#{ check_id }']")
    expect(rendered).to have_css("//input[@id='#{ check_id }']")
  end

  before do
    defence_request = DefenceRequest.new
    assign :defence_request, defence_request
    assign :defence_request_form, DefenceRequestForm.new(defence_request)

    assign(:policy, double(
                      :"create?" => true,
                      :"add_case_time_of_arrival?" => true,
                      :"interview_start_time_edit?" => true,
                    )
    )

    render
  end

  it "sets disable-when correctly" do
    assert_disable_set "defence_request_detainee_name", "defence_request_detainee_name_not_given"
    assert_disable_set "defence_request_detainee_address", "defence_request_detainee_address_not_given"

    assert_disable_set "defence_request_date_of_birth_day", "defence_request_date_of_birth_not_given"
    assert_disable_set "defence_request_date_of_birth_month", "defence_request_date_of_birth_not_given"
    assert_disable_set "defence_request_date_of_birth_year", "defence_request_date_of_birth_not_given"
  end

  it "sets show-when correctly" do
    assert_show_hide_set "div", "defence_request_appropriate_adult_true"
    assert_show_hide_set "div", "defence_request_interpreter_required_true"
    assert_show_hide_set "div", "defence_request_fit_for_interview_false"
  end
end