class UniqueIndexOnDsccNumber < ActiveRecord::Migration
  def change
    add_index :dscc_numbers, [:year_and_month, :number], unique: true
  end
end
