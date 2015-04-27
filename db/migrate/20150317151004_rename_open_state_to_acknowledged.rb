class RenameOpenStateToAcknowledged < ActiveRecord::Migration
  class DummyDefenseRequest < ActiveRecord::Base
    self.table_name = "defence_requests"
  end

  def up
    DummyDefenseRequest.where(state: "open").each do |dr|
      dr.update_attribute(:state, "acknowledged")
    end
  end

  def down
    DummyDefenseRequest.where(state: "acknowledged").each do |dr|
      dr.update_attribute(:state, "open")
    end
  end
end
