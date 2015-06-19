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

      time = format_date_and_time(defence_request.interview_start_time)

      content_tag :dl, class: "time-at" do
        display_value "interview_at", time
      end
    else
      content_tag :dl, class: "time-at" do
        display_value "interview_time", I18n.t("pending")
      end
    end
  end

  def label_text_for_form(attribute_name:, optional: false)
    if optional
      "#{t(attribute_name.to_s)} <span class=\"aside\">(#{t("optional")})</span>".html_safe
    else
      t(attribute_name.to_s)
    end
  end

  private

  #
  # Formats the given date as a string with just time if the date is today
  # Will format as date + time for dates that are not today
  #
  def format_date_and_time(date)
    date.day == Time.zone.now.day ? date.to_s(:time) : date_and_time_formatter(date)
  end

  def appropriate_adult_reason(defence_request)
    if defence_request.appropriate_adult?
      reason = t(defence_request.appropriate_adult_reason).downcase
      [t("appropriate_adult_reason").downcase, reason].join(" ")
    else
      ""
    end
  end
end
