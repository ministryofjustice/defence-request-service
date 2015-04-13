class RenameUuidColumns < ActiveRecord::Migration
  def change
    rename_column :defence_requests, :solicitor_uuid, :solicitor_uid
    rename_column :defence_requests, :cco_uuid, :cco_uid
  end
end
