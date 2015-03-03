require 'rails_helper'

RSpec.describe DateTimeBuilder do
  let(:todays_date) { DateTime.current }
  let(:valid_date_time_builder) { DateTimeBuilder.new({ 'day' => '01', 'month' => '01', 'year' => '2001', 'hour' => '01', 'min' => '01' }) }
  let(:valid_time_date_time_builder) { DateTimeBuilder.new({ 'hour' => '12', 'min' => '12' }) }
  let(:empty_hash_date_time_builder) { DateTimeBuilder.new({}) }
  let(:invalid_day) { DateTimeBuilder.new({ 'day' => 'XX', 'month' => '01', 'year' => '2001', 'hour' => '01', 'min' => '01' }) }
  let(:invalid_month) { DateTimeBuilder.new({ 'day' => '01', 'month' => 'XX', 'year' => '2001', 'hour' => '01', 'min' => '01' }) }
  let(:invalid_year) { DateTimeBuilder.new({ 'day' => '01', 'month' => '01', 'year' => 'XXXX', 'hour' => '01', 'min' => '01' }) }
  let(:invalid_hour) { DateTimeBuilder.new({ 'day' => '01', 'month' => '01', 'year' => '2001', 'hour' => 'XX', 'min' => '01' }) }
  let(:invalid_min) { DateTimeBuilder.new({ 'day' => '01', 'month' => '01', 'year' => '2001', 'hour' => '01', 'min' => 'XX' }) }
  let(:year_blank) { DateTimeBuilder.new({ 'day' => '01', 'month' => '01', 'year' => '', 'hour' => '01', 'min' => '01' }) }
  let(:month_blank) { DateTimeBuilder.new({ 'day' => '01', 'month' => '', 'year' => '2001', 'hour' => '01', 'min' => '01' }) }
  let(:day_blank) { DateTimeBuilder.new({ 'day' => '', 'month' => '01', 'year' => '2001', 'hour' => '01', 'min' => '01' }) }
  let(:hour_blank) { DateTimeBuilder.new({ 'day' => '01', 'month' => '01', 'year' => '2001', 'hour' => '', 'min' => '01' }) }
  let(:min_blank) { DateTimeBuilder.new({ 'day' => '01', 'month' => '01', 'year' => '2001', 'hour' => '01', 'min' => '' }) }
  let(:all_blank) { DateTimeBuilder.new({ 'day' => '', 'month' => '', 'year' => '', 'hour' => '', 'min' => '' }) }

  describe '#valid?' do

    it 'returns true with valid arguments' do
      expect(valid_date_time_builder.valid?).to eq true
      expect(valid_time_date_time_builder.valid?).to eq true
      expect(empty_hash_date_time_builder.valid?).to eq true
    end

    it 'returns false with invalid arguments' do
      expect(invalid_day.valid?).to eq false
      expect(invalid_month.valid?).to eq false
      expect(invalid_year.valid?).to eq false
      expect(invalid_hour.valid?).to eq false
      expect(invalid_min.valid?).to eq false
    end

  end

  describe '#value' do

    it 'returns the correct datetime object when passed year,month,day,hour,min' do
      expect(valid_date_time_builder.value).to eq Time.zone.local(2001, 01, 01, 01, 01, 0)
    end

    it 'returns todays date with time value when passed hour,min' do
      expect(valid_time_date_time_builder.value).to eq Time.zone.local(todays_date.year, todays_date.month, todays_date.day, 12, 12, 0)
    end

    it 'returns the correct datetime object when for now when passed an empty hash' do
      expect(empty_hash_date_time_builder.value).to eq Time.zone.local(todays_date.year, todays_date.month, todays_date.day,  todays_date.hour, todays_date.min, 0)
    end

    it 'returns nil when passed bad values' do
      expect(invalid_month.value).to eq nil
    end
  end

  describe '#present?' do
    it 'returns false if all arguments are blank' do
      expect(all_blank.present?).to eq false
    end

    it 'returns true if any argument are included' do
      expect(day_blank.present?).to eq true
    end
  end

  describe '#year?' do
    it 'returns false if year argument is blank' do
      expect(year_blank.year?).to eq false
    end

    it 'returns true if year argument are included' do
      expect(valid_date_time_builder.year?).to eq true
    end
  end

  describe '#month?' do
    it 'returns false if month argument is blank' do
      expect(month_blank.month?).to eq false
    end

    it 'returns true if month argument are included' do
      expect(valid_date_time_builder.month?).to eq true
    end
  end

  describe '#day?' do
    it 'returns false if day argument is blank' do
      expect(day_blank.day?).to eq false
    end

    it 'returns true if day argument are included' do
      expect(valid_date_time_builder.day?).to eq true
    end
  end

  describe '#hour?' do
    it 'returns false if hour argument is blank' do
      expect(hour_blank.hour?).to eq false
    end

    it 'returns true if hour argument are included' do
      expect(valid_date_time_builder.hour?).to eq true
    end
  end

  describe '#min?' do
    it 'returns false if min argument is blank' do
      expect(min_blank.min?).to eq false
    end

    it 'returns true if min argument are included' do
      expect(valid_date_time_builder.min?).to eq true
    end
  end
end