class AddTimestampsToDefenceRequests < ActiveRecord::Migration
  def change
    add_timestamps(:defence_requests, null: true)
  end
end
