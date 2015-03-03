require 'rails_helper'

RSpec.describe DateBuilder do
  let(:todays_date) { DateTime.current }
  let(:valid_date_builder) { DateBuilder.new({ 'day' => '01', 'month' => '01', 'year' => '2001' }) }
  let(:empty_hash_date_builder) { DateBuilder.new({}) }
  let(:invalid_day) { DateBuilder.new({ 'day' => 'XX', 'month' => '01', 'year' => '2001' }) }
  let(:invalid_month) { DateBuilder.new({ 'day' => '01', 'month' => 'XX', 'year' => '2001' }) }
  let(:invalid_year) { DateBuilder.new({ 'day' => '01', 'month' => '01', 'year' => 'XXXX' }) }
  let(:year_blank) { DateBuilder.new({ 'day' => '01', 'month' => '01', 'year' => '' }) }
  let(:month_blank) { DateBuilder.new({ 'day' => '01', 'month' => '', 'year' => '2001' }) }
  let(:day_blank) { DateBuilder.new({ 'day' => '', 'month' => '01', 'year' => '2001' }) }

  describe '#valid?' do

    it 'returns true with valid arguments' do
      expect(valid_date_builder.valid?).to eq true
      expect(empty_hash_date_builder.valid?).to eq true
    end

    it 'returns false with invalid arguments' do
      expect(invalid_day.valid?).to eq false
      expect(invalid_month.valid?).to eq false
      expect(invalid_year.valid?).to eq false
    end

  end

  describe '#value' do

    it 'returns the correct date object when passed year,month,day' do
      expect(valid_date_builder.value).to eq Date.new(2001, 01, 01)
    end

    it 'returns the correct datetime object when for now when passed an empty hash' do
      expect(empty_hash_date_builder.value).to eq Date.new(todays_date.year, todays_date.month, todays_date.day)
    end

    it 'returns nil when passed bad values' do
      expect(invalid_month.value).to eq nil
    end
  end

  describe '#present?' do
    it 'returns false if any argument is blank' do
      expect(day_blank.present?).to eq false
    end

    it 'returns true if all argument are included' do
      expect(valid_date_builder.present?).to eq true
    end
  end

  describe '#year?' do
    it 'returns false if any argument is blank' do
      expect(year_blank.year?).to eq false
    end

    it 'returns true if all argument are included' do
      expect(valid_date_builder.year?).to eq true
    end
  end

  describe '#month?' do
    it 'returns false if any argument is blank' do
      expect(month_blank.month?).to eq false
    end

    it 'returns true if all argument are included' do
      expect(valid_date_builder.month?).to eq true
    end
  end

  describe '#day?' do
    it 'returns false if any argument is blank' do
      expect(day_blank.present?).to eq false
    end

    it 'returns true if all argument are included' do
      expect(valid_date_builder.present?).to eq true
    end
  end
end