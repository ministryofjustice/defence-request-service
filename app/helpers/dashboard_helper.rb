module DashboardHelper
  def tab_class(type:)
    if params[:id]
      "active_tab" if params[:id] == type
    else
      "active_tab" if type == :active
    end
  end

  def day_text(dr)
    if dr.created_at < Time.zone.now.beginning_of_day
      short_date_formatter(dr.created_at)
    end
  end

  def arriving_text(dr)
    if dr.created_at < Time.zone.now.beginning_of_day
      # before today
      t("arriving")
    else
      if dr.created_at < Time.zone.now.end_of_day
        # today
        t("arriving_at")
      else
        # after today
        t("arrived_at")
      end
    end
  end

  def render_custody_number(custody_number)
    "#{t("custody_number_prefix")}&nbsp;#{custody_number}".html_safe
  end
end
