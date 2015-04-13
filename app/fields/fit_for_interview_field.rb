class FitForInterviewField
  include ActiveModel::Model

  attr_accessor :fit_for_interview

  def value
    fit_for_interview == 'yes' ? true : false
  end

  def self.from_persisted_value value
    if value == true
      FitForInterviewField.new({fit_for_interview: 'yes'})
    else
      FitForInterviewField.new({fit_for_interview: 'no'})
    end
  end

  def present?
    fit_for_interview.present?
  end

  def blank?
    !present?
  end
end
