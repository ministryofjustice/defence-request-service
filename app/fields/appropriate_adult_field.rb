class AppropriateAdultField
  include ActiveModel::Model

  attr_accessor :appropriate_adult

  def value
    appropriate_adult == 'yes' ? true : false
  end

  def self.from_persisted_value value
    if value == true
      AppropriateAdultField.new({appropriate_adult: 'yes'})
    else
      AppropriateAdultField.new({appropriate_adult: 'no'})
    end
  end

  def present?
    appropriate_adult.present?
  end
end
