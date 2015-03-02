class GovukTimeDateValidator

  def initialize(record, field, builder)
    @record = record
    @field = field
    @builder = builder
  end

  def validate
    if builder
      govuk_date_time
      govuk_date_time_year
      govuk_date_time_month
      govuk_date_time_day
      govuk_date_time_hour
      govuk_date_time_min
    end
  end

  private

  attr_reader :record, :field, :builder

  def govuk_date_time_year
    record.errors.add field, :invalid_year unless builder.year?
  end

  def govuk_date_time_month
    record.errors.add field, :invalid_month unless builder.month?
  end

  def govuk_date_time_day
    record.errors.add field, :invalid_day unless builder.day?
  end

  def govuk_date_time_hour
    record.errors.add field, :invalid_hour unless builder.hour?
  end

  def govuk_date_time_min
    record.errors.add field, :invalid_min unless builder.min?
  end

  def govuk_date_time
    record.errors.add field, :invalid unless builder.valid?
  end

end

