class DsccNumber < ActiveRecord::Base
  has_one :defence_request

  validates_uniqueness_of :number, scope: [:year_and_month]
  validates :number, :year_and_month, :extension, presence: true

  def to_s
    "%s%05d%s" % [prefix, number, extension]
  end

  private

  def prefix
    year_and_month.strftime("%y%m")
  end
end
