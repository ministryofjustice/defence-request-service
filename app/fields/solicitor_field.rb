class SolicitorField
  include ActiveModel::Model

  attr_accessor :email, :solicitor_id

  def value
   solicitor
  end

  def solicitor
    if email
      User.find_by_email email
    elsif solicitor_id
      User.find_by_id solicitor_id
    end
  end

  def present?
    [email, solicitor_id].any? &:present?
  end

  def self.from_persisted_value solicitor
    if solicitor
      SolicitorField.new solicitor_id: solicitor.id, email: solicitor.email
    else
      SolicitorField.new
    end
  end
end
