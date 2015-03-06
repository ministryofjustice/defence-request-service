class SolicitorAssociationHandler
  include ActiveModel::Model

  def self.model_name
    ActiveModel::Name.new(self, nil, '')
  end

  attr_accessor :solicitor_id

  def value
    User.find_by(id: solicitor_id)
  end

  def self.from_solicitor solicitor
    SolicitorHandler.new.tap do |s|
      s.solicitor_id = solicitor.id
    end
  end
end
