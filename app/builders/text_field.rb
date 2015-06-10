class TextField
  attr_reader :f, :attribute

  delegate :label, :error?, :id, to: :attribute

  def initialize(form, attribute, options)
    @f = form
    @attribute = attribute
    @class =  options.fetch :class, nil
    @input_data = options.fetch :input_data, nil
    @input_class = options.fetch :input_class, nil
    build_classes!
  end

  def content(content)
    f.content_tag :div, div_options do
      labelled_text_field + content
    end
  end

  private

  def div_options
    @div_options ||= {}.tap { |opts|
      opts[:class] = classes
      opts[:id] = id
    }.compact
  end

  def input_options
    @input_options ||= {}.tap { |opts|
      opts[:class] = @input_class
      opts[:data] = @input_data
      opts[:maxlength] = max_length
    }.compact
  end

  def classes
    @classes.join(" ")
  end

  def build_classes!
    @classes = ["form-group", @class].compact
    @classes << "error" if error?
  end

  def labelled_text_field
    [label, value].join("\n").html_safe
  end

  def value
    f.text_field @attribute.attribute, input_options
  end

  def max_length
    if validator = validators.detect{ |x| x.is_a?(ActiveModel::Validations::LengthValidator) }
      validator.options[:maximum]
    end
  end

  def validators
    f.object.class.validators_on @attribute.attribute
  end
end
