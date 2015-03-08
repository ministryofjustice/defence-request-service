class AppropriateAdultField
  include ActiveModel::Model

  def initialize yes_or_no
    @_value = yes_or_no == 'yes'
  end

  def value
    @_value
  end

  def self.from_persisted_value bool
    str = bool ? 'yes' : 'no'
    AppropriateAdultField.new str
  end

end
