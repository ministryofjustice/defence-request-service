class AddUidIndicesToDefenceRequest < ActiveRecord::Migration
  def change
    add_index :defence_requests, :solicitor_uid
    add_index :defence_requests, :cco_uid
  end
end
