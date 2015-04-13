class CreateDsccNumbers < ActiveRecord::Migration
  def change
    create_table :dscc_numbers do |t|
      t.integer :defence_request_id, null: false
      t.date :year_and_month
      t.integer :number
      t.string :extension, limit: 1, default: 'Z'

      t.timestamps null: false
    end

    add_index :dscc_numbers, [:defence_request_id], unique: true
  end
end
