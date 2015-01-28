class CreateDefenceRequests < ActiveRecord::Migration
  def change
    create_table :defence_requests do |t|
      t.string :solicitor_type, null: false
    end
  end
end
