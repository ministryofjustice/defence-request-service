class DsccNumberGenerator

  #
  # Generates a DSCC number for a DefenceRequest in 1 query
  #
  # Need to run within a table lock to elimate any race conditions if more
  # than 1 DSCC number is generated simultaneously
  #
  # Current DSCC number is yymmnnnnnc where
  # yymm is the current year and month
  # nnnnn is a 5 digit number
  # c is the character 'Z'
  #
  # If there is more than 99,999 DSCC numbers generated in a given month
  # the next DSCC number rolls over into the next month
  #

  SUFFIX = "Z".freeze

  def initialize(defence_request)
    @defence_request = defence_request
  end

  def generate!
    result = defence_request.class.connection.execute(dscc_number_generation_sql)
    result.first.symbolize_keys if result.first
  end

  private

  attr_reader :defence_request

  delegate :id, :created_at, to: :defence_request

  def prefix
    created_at.strftime('%y%m')
  end

  def dscc_number_generation_sql
    <<-SQL.strip_heredoc
      BEGIN;
      LOCK TABLE defence_requests IN ACCESS EXCLUSIVE MODE;

      WITH next_dscc_numbers AS (
        SELECT CAST(MAX(number) as INTEGER) + 1 as next_dscc_number
        FROM (
          SELECT substring(dscc_number from 1 for 9) AS number
          FROM defence_requests
          WHERE dscc_number > '#{prefix}%'

          UNION

          SELECT '#{prefix}00000' AS number
        ) AS dscc_numbers
      )

      UPDATE defence_requests
      SET updated_at = current_timestamp, dscc_number = next_dscc_number || '#{SUFFIX}' FROM next_dscc_numbers
      WHERE id = #{id} AND dscc_number IS NULL;

      COMMIT;

      SELECT dscc_number, updated_at FROM defence_requests WHERE id = #{id};
    SQL
  end
end