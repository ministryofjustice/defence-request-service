class RemoveAgeFromDefenceRequest < ActiveRecord::Migration
  def change
    remove_column :defence_requests, :detainee_age, :integer
  end
end
