class DsccNumberGenerator

  #
  # Generates a DSCC number for a DefenceRequest in 1 query
  #
  # Run within a table lock to elimate any race conditions when more
  # than 1 DSCC number is generated simultaneously
  #
  # Current DSCC number is yymmnnnnnc where
  # yymm is the current year and month
  # nnnnn is a 5 digit number
  # c is an upper case character
  #
  # Characters start with 'D' to distinguish DRS numbers from legacy systems
  # whose numbers start with 'A'
  #
  # If there is more than 99,999 DSCC numbers generated in a given month
  # the next DSCC number will use the next character
  # eg given 150499999D the next number would be 150400000E
  #

  DEFAULT_SUFFIX = "D".freeze

  class NotPersistedError < StandardError
  end

  def initialize(defence_request)
    @defence_request = defence_request
    @suffixes = (DEFAULT_SUFFIX.."Z").to_a
  end

  def generate!
    validate_defence_request!

    # TODO: this method can be written in a better way. Look at this again earlier than 1030 at night.
    result = nil

    loop do
      result = try_generate next_suffix

      break if suffixes.empty? || result.first['dscc_number']
    end

    result.first.symbolize_keys if result.first
  end

  private

  attr_reader :defence_request, :suffixes

  delegate :id, :created_at, to: :defence_request

  def validate_defence_request!
    raise ArgumentError.new("DefenceRequest cannot be nil") unless defence_request
    raise ArgumentError.new("DefenceRequest does not have a positive non-zero id") unless defence_request.try(:id).to_i > 0
    raise ArgumentError.new("DefenceRequest does not have valid created_at timestamp") unless defence_request.try(:created_at).is_a?(Time)
  end

  def try_generate(suffix)
    defence_request.class.connection.execute(dscc_number_generation_sql(suffix))
  end

  def prefix
    created_at.strftime('%y%m')
  end

  def previous_month_prefix
    (created_at - 1.month).strftime('%y%m')
  end

  def next_suffix
    suffixes.shift
  end

  def dscc_number_generation_sql(suffix)
    <<-SQL.strip_heredoc
      BEGIN;
      LOCK TABLE defence_requests IN ACCESS EXCLUSIVE MODE;

      WITH next_dscc_numbers AS (
        SELECT CAST(MAX(number) as INTEGER) + 1 as next_dscc_number
        FROM (
          SELECT substring(dscc_number from 1 for 9) AS number
          FROM defence_requests
          WHERE dscc_number LIKE '#{prefix}%' AND dscc_number LIKE '%#{suffix}'

          UNION

          SELECT '#{previous_month_prefix}99999' AS number
        ) AS dscc_numbers
      )

      UPDATE defence_requests
      SET updated_at = current_timestamp, dscc_number = next_dscc_number || '#{suffix}' FROM next_dscc_numbers
      WHERE id = #{id} AND dscc_number IS NULL AND next_dscc_number < #{ (prefix + '99999').to_i };

      COMMIT;

      SELECT dscc_number, updated_at FROM defence_requests WHERE id = #{id};
    SQL
  end
end