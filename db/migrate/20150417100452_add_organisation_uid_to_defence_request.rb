class AddOrganisationUidToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :organisation_uid, :uuid
  end
end
