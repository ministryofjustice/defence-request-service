class TextField < FormGroup

  def initialize(form, attribute, options)
    @input_data = options.fetch :input_data, nil
    @input_class = options.fetch :input_class, nil
    @multiline = options.fetch :multiline, false
    super
  end

  private

  def content_body(inner_body)
    labelled_text_field + inner_body
  end

  def input_options
    @input_options ||= {}.tap { |opts|
      opts[:class] = @input_class
      opts[:data] = @input_data
      opts[:maxlength] = max_length
    }.compact
  end

  def labelled_text_field
    [label, value].join("\n").html_safe
  end

  def value
    if @multiline
      f.text_area attribute, input_options.merge({rows: @multiline})
    else
      f.text_field attribute, input_options
    end
  end

  def max_length
    if validator = validators.detect{ |x| x.is_a?(ActiveModel::Validations::LengthValidator) }
      validator.options[:maximum]
    end
  end

  def validators
    f.object.class.validators_on attribute
  end
end
