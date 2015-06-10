class FormGroup
  attr_reader :f, :attribute

  delegate :label, :error?, :id, to: :attribute

  def initialize(form, attribute, options)
    @f = form
    @attribute = attribute
    @class = options.fetch :class, nil
    @data = options.fetch :data, nil
    build_classes!
  end

  def content(content)
    f.content_tag :div, div_options do
      label + content
    end
  end

  private

  def div_options
    @div_options ||= {}.tap { |opts|
      opts[:class] = classes
      opts[:id] = id
      opts[:data] = @data
    }.compact
  end

  def classes
    @classes.join(" ")
  end

  def build_classes!
    @classes = ["form-group", @class].compact
    if error?
      @classes.delete("panel-indent")
      @classes << "error"
    end
  end
end
