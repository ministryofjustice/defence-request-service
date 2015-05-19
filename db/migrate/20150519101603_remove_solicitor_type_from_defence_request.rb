class RemoveSolicitorTypeFromDefenceRequest < ActiveRecord::Migration
  def change
    remove_column :defence_requests, :solicitor_type, :string, null: false
  end
end
