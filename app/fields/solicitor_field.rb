class SolicitorField
  include ActiveModel::Model

  attr_accessor :email, :solicitor_id

  def value
   solicitor
  end

  def solicitor
    if email
      User.find_by_id email
    elsif solicitor_id
      User.find_by_id solicitor_id
    end
  end

  def self.from_persisted_value solicitor
    id = solicitor.id if solicitor
    SolicitorField.new solicitor_id: id
  end
end
