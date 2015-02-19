class AddCcoIdToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :cco_id, :integer
  end
end
