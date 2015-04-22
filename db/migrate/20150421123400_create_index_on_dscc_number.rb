class CreateIndexOnDsccNumber < ActiveRecord::Migration
  def up
    change_column :defence_requests, :dscc_number, :text, :limit => 10
    execute "CREATE INDEX dscc_number_index ON defence_requests USING gist (dscc_number gist_trgm_ops);"
  end

  def down
    execute "DROP INDEX dscc_number_index"
  end
end
