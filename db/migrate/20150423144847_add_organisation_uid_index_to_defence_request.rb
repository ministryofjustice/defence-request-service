class AddOrganisationUidIndexToDefenceRequest < ActiveRecord::Migration
  def change
    add_index :defence_requests, :organisation_uid
  end
end
