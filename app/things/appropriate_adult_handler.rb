class AppropriateAdultHandler
  include ActiveModel::Model

  def self.model_name
    ActiveModel::Name.new(self, nil, 'AppropriateAdult')
  end

  def value(checkbox)
    1
  end

  def self.from_value value
    AppropriateAdultHandler.new
  end

end
