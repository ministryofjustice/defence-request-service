nclass AddAppropriateAdultReasonToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :appropriate_adult_reason, :text
  end
end
