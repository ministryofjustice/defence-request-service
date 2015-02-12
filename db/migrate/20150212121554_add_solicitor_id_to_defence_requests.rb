class AddSolicitorIdToDefenceRequests < ActiveRecord::Migration
  def change
    add_column :defence_requests, :solicitor_id, :integer
    add_index :defence_requests, :solicitor_id
  end
end
