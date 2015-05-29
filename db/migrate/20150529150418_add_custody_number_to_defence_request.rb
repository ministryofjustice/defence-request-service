class AddCustodyNumberToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :custody_number, :string
    add_index :defence_requests, :custody_number
  end
end
