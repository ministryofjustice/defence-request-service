class DsccNumber < ActiveRecord::Base
  MAX_RETRIES = 10

  after_validation :try_a_different_number, if: -> { require 'pry'; binding.pry; errors.present? }

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

  def has_retries_left?
    remaining_retries > 0
  end

  def try_a_different_number
    @retries = @retries ? @retries + 1 : 1
    reassign_random_number

    has_retries_left? && save
  end

  def remaining_retries
    MAX_RETRIES - @retries
  end

  def reassign_random_number
    self.number = random_number
  end

  def random_number
    Random.rand(10**5 -1)
  end

  def clear_retries
    # We want to stop callbacks, so we need to
    # return something falsey - nil instead of
    # 0
    @retries = nil
  end
end
