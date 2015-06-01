class RemoveInvestigatingOfficerShoulderNumber < ActiveRecord::Migration
  def change
    remove_column :defence_requests, :investigating_officer_shoulder_number
  end
end
