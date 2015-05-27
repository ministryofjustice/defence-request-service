module DefenceRequestsHelper

  def solicitor_id(solicitor_hash)
    "solicitor-#{solicitor_hash['id']}"
  end

  def not_given_formatter(defence_request, field, translation = "not_given")
    defence_request.send(field).blank? ? I18n.t(translation) : defence_request.send(field)
  end

  def date_not_given_formatter(defence_request, field)
    defence_request.send(field).blank? ? I18n.t("not_given") : date_formatter(defence_request.send(field))
  end

  def interview_at(defence_request)
    if defence_request.interview_start_time?

      time = format_date_and_time defence_request.interview_start_time

      content_tag :dl, class: "time-at" do
        display_value "interview_at", time
      end
    else
      content_tag :dl, class: "time-at" do
        display_value "interview_time", I18n.t("pending")
      end
    end
  end

  def arriving_at(defence_request)
    if defence_request.solicitor_time_of_arrival?

      time = format_date_and_time defence_request.solicitor_time_of_arrival

      content_tag :dl, class: "time-at" do
        display_value "arriving_at", time, id: :solicitor_time_of_arrival
      end
    end
  end

  def data_chooser_setup(time_to_edit, set_default_date)
    today = Date.today
    tomorrow = today + 1
    initial_date = initial_date(time_to_edit, set_default_date)
    initial_date_type = initial_date_type(initial_date, today, tomorrow)

    [today, tomorrow, initial_date, initial_date_type]
  end

  private

  #
  # Formats the given date as a string with just time if the date is today
  # Will format as date + time for dates that are not today
  #
  def format_date_and_time(date)
    date.day == Time.zone.now.day ? date.to_s(:time) : date.to_s(:short)
  end

  def initial_date(time_to_edit, set_default_date)
    if time_to_edit
      time_to_edit.to_date
    elsif set_default_date
      Date.today
    end
  end

  def initial_date_type(initial_date, today, tomorrow)
    if initial_date.nil?
      "blank"
    elsif initial_date == today
      "today"
    elsif initial_date == tomorrow
      "tomorrow"
    elsif initial_date < today
      "in_past"
    else
      "after_tomorrow"
    end
  end

end
