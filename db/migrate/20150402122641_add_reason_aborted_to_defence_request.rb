class AddReasonAbortedToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :reason_aborted, :text
  end
end
