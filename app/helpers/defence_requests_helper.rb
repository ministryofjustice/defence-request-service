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
                        elsif
                          "after_tomorrow"
                        end
    [today, tomorrow, initial_date, initial_date_type]
  end

end
