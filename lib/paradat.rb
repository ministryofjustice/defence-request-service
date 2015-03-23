module Paradat
  class Form
    include ActiveModel::Model
    extend Forwardable

    attr_reader :base_model, :decorated_fields

    def self.delegates_fields *attrs
      attrs.each do |attr_name|
        def_delegator :@base_model, "#{attr_name}_before_type_cast", attr_name
      end
    end

    @@decorated_field_classes = {}
    def self.decorates_field field_name, klass
      @@decorated_field_classes[field_name] = klass
    end

    def self.underlying_model klass, accessor=klass.model_name.singular
      alias_method  accessor.to_sym, :base_model
      def_delegator :@base_model, :model_name
    end

    def initialize(base_model)
      @base_model = base_model
      @decorated_fields = {}
      register_fields
    end

    def submit(params)
      @decorated_fields.select!{ |k, v| params.include?(k) }

      params_without_fields =  params.reject { |k, _| @decorated_fields.keys.include? k.to_sym}
      @base_model.assign_attributes params_without_fields

      @decorated_fields.dup.each do |field_name, field_value|
        field_value = field_value.class.new params[field_name]
        @decorated_fields[field_name] = field_value
        @base_model.assign_attributes({ field_name => field_value.value })
      end

      if @decorated_fields.all?(&valid_if_present?) & @base_model.valid?
        @base_model.save!
        true
      else
        add_errors_to_form
        false
      end
    end

    private

    def register_fields
      @@decorated_field_classes.each do |field_name, klass|
        @decorated_fields[field_name] = klass.from_persisted_value @base_model.send field_name
      end
    end

    def add_errors_to_form
      @base_model.errors.messages.each do |field_name, error_message|
        self.errors[field_name] = error_message.join ", "
      end

      @decorated_fields.map(&:to_a).reject(&valid_if_present?).each do |field_name, field_value|
        if field_value.present?
          self.errors[field_name].clear
          self.errors[field_name] = field_value.errors.full_messages.join ", "
        end
      end
    end

    def valid_if_present?
      ->(field) do
        field_value = field.last
        field_value.valid? || field_value.blank?
      end
    end
  end

  class Field
    def value
      raise NotImplementedError
    end

    def present
      raise NotImplementedError
    end

    def self.from_persisted_value
      raise NotImplementedError
    end
  end
end
