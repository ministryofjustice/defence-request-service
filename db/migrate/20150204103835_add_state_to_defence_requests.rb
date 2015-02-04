class AddStateToDefenceRequests < ActiveRecord::Migration
  def change
    add_column :defence_requests, :state, :string
  end
end
