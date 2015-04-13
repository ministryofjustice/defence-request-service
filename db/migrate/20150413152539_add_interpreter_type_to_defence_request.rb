class AddInterpreterTypeToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :interpreter_type, :text
  end
end
