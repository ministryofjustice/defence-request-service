class AddInterpreterRequiredToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :interpreter_required, :bool, null: false, default: false
  end
end
