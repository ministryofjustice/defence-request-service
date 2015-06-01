module DefenceRequestHelpers
  def stub_defence_request_transition_strategy(strategy:, method:, value:)
    allow_any_instance_of(strategy).to receive(method).and_return(value)
  end

  def expect_email_with_case_details_to_have_been_sent_to_assigned_solicitor
    expect(ActionMailer::Base.deliveries.size).to eq 1
  end

  def abort_defence_request(options = {})
    click_link "Abort"
    fill_in "Reason aborted", with: options.fetch(:reason) { "Reason for abort" }
    click_button "Abort"
  end

  def fill_in_defence_request_form(options = {})
    if options.fetch(:edit) { false }
      within ".case-details" do
        fill_in "Offences", with: "BadMurder"
        fill_in "defence_request_interview_start_time_day", with: "01"
        fill_in "defence_request_interview_start_time_month", with: "01"
        fill_in "defence_request_interview_start_time_year", with: "2001"
        fill_in "defence_request_interview_start_time_hour", with: "01"
        fill_in "defence_request_interview_start_time_min", with: "01"
      end
      within ".detainee" do
        fill_in "Full Name", with: "Mannie Badder"
      end
    else
      within ".case-details" do
        fill_in "defence_request_investigating_officer_name", with: "Dave Mc.Copper"
        fill_in "defence_request_investigating_officer_contact_number", with: "0207 111 0000"
        fill_in "Custody number", with: "AN14574637587"
        fill_in "Offences", with: "BadMurder"
        fill_in "defence_request_circumstances_of_arrest", with: "He looked a bit shady"
        choose "defence_request_fit_for_interview_true"
        fill_in "defence_request_time_of_arrest_day", with: "02"
        fill_in "defence_request_time_of_arrest_month", with: "02"
        fill_in "defence_request_time_of_arrest_year", with: "2002"
        fill_in "defence_request_time_of_arrest_hour", with: "02"
        fill_in "defence_request_time_of_arrest_min", with: "02"
        fill_in "defence_request_time_of_arrival_day", with: "01"
        fill_in "defence_request_time_of_arrival_month", with: "01"
        fill_in "defence_request_time_of_arrival_year", with: "2001"
        fill_in "defence_request_time_of_arrival_hour", with: "01"
        fill_in "defence_request_time_of_arrival_min", with: "01"
        fill_in "defence_request_time_of_detention_authorised_day", with: "03"
        fill_in "defence_request_time_of_detention_authorised_month", with: "03"
        fill_in "defence_request_time_of_detention_authorised_year", with: "2003"
        fill_in "defence_request_time_of_detention_authorised_hour", with: "03"
        fill_in "defence_request_time_of_detention_authorised_min", with: "03"
      end
    end
    if options.fetch(:not_given) { false }
      within ".detainee" do
        choose options.fetch(:gender) { "Male" }
        choose "defence_request_appropriate_adult_false"
        choose "defence_request_interpreter_required_false"
        check "defence_request_detainee_name_not_given"
        check "defence_request_detainee_address_not_given"
        check "defence_request_date_of_birth_not_given"
      end
    else
      within ".detainee" do
        fill_in "Full Name", with: "Mannie Badder"
        choose options.fetch(:gender) { "Male" }
        fill_in "defence_request_date_of_birth_year", with: "1976"
        fill_in "defence_request_date_of_birth_month", with: "01"
        fill_in "defence_request_date_of_birth_day", with: "01"
        fill_in "defence_request_detainee_address",
                with: "House of the rising sun, Letsby Avenue, Right up my street, London, Greater London, XX1 1XX"
        choose "defence_request_appropriate_adult_false"
        choose "defence_request_interpreter_required_false"
      end
    end
    fill_in "Comments", with: "This is a very bad man. Send him down..."
  end

  def an_audit_should_exist_for_the_defence_request_creation
    expect(DefenceRequest.first.audits.length).to eq 1
    audit = DefenceRequest.first.audits.first

    expect(audit.auditable_type).to eq "DefenceRequest"
    expect(audit.action).to eq "create"
  end
end
