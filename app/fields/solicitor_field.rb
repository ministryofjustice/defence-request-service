class SolicitorField
  include ActiveModel::Model

  attr_accessor :email, :solicitor, :solicitor_uid

  def value
    solicitor
  end

  def present?
    [email, solicitor_uid].any? &:present?
  end

  def self.from_persisted_value solicitor
    if solicitor
      SolicitorField.new(
        solicitor_uid: solicitor.uid,
        email: solicitor.email,
        solicitor: solicitor
      )
    else
      SolicitorField.new
    end
  end

  def blank?
    !present?
  end
end
