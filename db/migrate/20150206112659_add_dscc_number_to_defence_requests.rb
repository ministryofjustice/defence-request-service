class AddDsccNumberToDefenceRequests < ActiveRecord::Migration
  def change
    add_column :defence_requests, :dscc_number, :string
  end
end
