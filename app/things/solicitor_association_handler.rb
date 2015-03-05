class SolicitorAssociationHandler
  include ActiveModel::Model

  def self.model_name
    ActiveModel::Name.new(self, nil, 'DateOfBirth')
  end

  attr_accessor :solicitor_id

  validate do
    errors.add :solicitor_id , 'bad solicitor' if true
  end

  def value
    User.find_by(id: solicitor_id)
  end

  def self.from_solicitor_id
    SolicitorAssociationHandler.new
  end
end
