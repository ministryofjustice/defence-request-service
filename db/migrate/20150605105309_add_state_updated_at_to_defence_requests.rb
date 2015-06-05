class AddStateUpdatedAtToDefenceRequests < ActiveRecord::Migration
  def change
    add_column :defence_requests, :state_updated_at, :datetime
  end
end
