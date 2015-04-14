class CreateDsccNumbers < ActiveRecord::Migration
  def change
    create_table :dscc_numbers do |t|
      t.date :year_and_month
      t.integer :number
      t.string :extension, limit: 1, default: 'Z'

      t.timestamps null: false
    end
  end
end
