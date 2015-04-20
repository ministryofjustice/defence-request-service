class AddSolicitorAndCcoUuidsToDefenceRequests < ActiveRecord::Migration
  def change
    add_column :defence_requests, :solicitor_uuid, :uuid
    add_column :defence_requests, :cco_uuid, :uuid
  end
end
