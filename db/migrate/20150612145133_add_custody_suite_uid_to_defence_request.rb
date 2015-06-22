class AddCustodySuiteUidToDefenceRequest < ActiveRecord::Migration
  def up
    raise ActiveRecord::MigrationError.new("You need to erase all Defence Requests") if DefenceRequest.count > 0

    add_column :defence_requests, :custody_suite_uid, :uuid, null: false
  end

  def down
    remove_column :defence_requests, :custody_suite_uid
  end
end
