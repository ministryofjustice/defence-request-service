class MoveDsccNumberToValueModel < ActiveRecord::Migration
  def change
    remove_column :defence_requests, :dscc_number, :string
    add_column :defence_requests, :dscc_number_id, :integer
    add_index :defence_requests, [:dscc_number_id], unique: true
  end
end
