module FormHelper
  def remote_form_for(record, remote_enabled, options = {}, &block)
    form_options = options
    form_options.merge!({remote: true, authenticity_token: true}) if remote_enabled

    form_for(record, form_options, &block)
  end
end