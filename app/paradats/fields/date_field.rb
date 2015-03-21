class DateField < Paradat::Field
  include ActiveModel::Model

  attr_accessor :day, :month, :year

  validate do
    begin
      Date.new year.to_i, month.to_i, day.to_i
    rescue => e
      errors.add :base, "Invalid Date"
    end
  end

  validates :day, :month, :year, numericality: true

  def present?
    [year, month, day].any? &:present?
  end

  def value
    Date.new year.to_i, month.to_i, day.to_i rescue nil
  end

  def self.from_persisted_value date
    DateField.new.tap do |dob|
      if date
        dob.day = date.day
        dob.month = date.month
        dob.year = date.year
      end
    end
  end

end
