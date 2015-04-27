class CreateUniqueIndexOnDsccNumber < ActiveRecord::Migration
  def change
    add_index :defence_requests, :dscc_number, unique: true
  end
end