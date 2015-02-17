class AddDetaineeAgeToDefenceRequests < ActiveRecord::Migration
  def change
    add_column :defence_requests, :detainee_age, :integer
  end
end
