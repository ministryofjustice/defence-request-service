module ApplicationHelper
  def flash_messages(opts = {})
    flash.to_h.slice('notice', 'alert').each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert flash #{bootstrap_class_for(msg_type)} fade in") do
        concat content_tag(:button, 'x', class: 'close', data: {dismiss: 'alert'})
        concat safe_join(Array(message), tag(:br))
      end)
    end
    nil
  end

  private
  def bootstrap_class_for(flash_type)
    {alert: 'alert-danger', notice: 'alert-info'}[flash_type.to_sym] || flash_type.to_s
  end
end
