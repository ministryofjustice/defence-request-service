module DefenceRequestsHelper

  def solicitor_id(solicitor_hash)
    "solicitor-#{solicitor_hash['id']}"
  end

  def data_chooser_setup(date_to_edit)
    today = Date.today
    tomorrow = today + 1
    initial_date = (date_to_edit || today).to_date
    initial_date_type = if initial_date == today
                          "today"
                        elsif initial_date == tomorrow
                          "tomorrow"
                        elsif initial_date < today
                          "in_past"
                        else
                          "after_tomorrow"
                        end
    [today, tomorrow, initial_date, initial_date_type]
  end

  def detainee_address(defence_request)
    attributes = %i[house_name address_1 address_2 city county postcode]
    fields = attributes.map { |f| defence_request.send(f) }.compact

    if fields.blank?
      I18n.t("address_not_given")
    else
      fields.join(", ")
    end
  end

  def interview_start_time(defence_request)
    value = if @defence_request.interview_start_time?
              date_and_time_formatter(@defence_request.interview_start_time)
            else
              I18n.t("interview_time_pending")
            end
    display_value "interview_start_time", value
  end
end
