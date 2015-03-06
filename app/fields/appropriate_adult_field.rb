class AppropriateAdultHandler
  include ActiveModel::Model

  def self.model_name
    ActiveModel::Name.new(self, nil, 'AppropriateAdult')
  end

  def value(checkbox)
    @_value
  end

  def self.from_original bool
    AppropriateAdultHandler.new.tap do |a|
      a.instance_variable_set(:@_value, bool)
    end
  end

end
