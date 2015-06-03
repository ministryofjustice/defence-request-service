class ChangeAppropriateAdultReasonToString < ActiveRecord::Migration
  def change
    change_column :defence_requests, :appropriate_adult_reason, :string
  end
end
