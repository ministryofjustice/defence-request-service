class RemoveUserAssociationsFromDefenceRequests < ActiveRecord::Migration
  def change
    remove_index :defence_requests, column: :solicitor_id
    remove_column :defence_requests, :solicitor_id, :integer
    remove_column :defence_requests, :cco_id, :integer
  end
end
