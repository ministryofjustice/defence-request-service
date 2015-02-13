class AddInterviewStartTimeToDefenceRequests < ActiveRecord::Migration
  def change
    add_column :defence_requests, :interview_start_time, :datetime
  end
end
