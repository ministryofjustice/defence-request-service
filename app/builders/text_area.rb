class TextArea < TextField
  DEFAULT_ROWS = 5

  def initialize(form, attribute, options)
    @rows = options.fetch(:rows, DEFAULT_ROWS)
    super
  end

  def value
    f.text_area attribute, input_options.merge({rows: @rows})
  end
end