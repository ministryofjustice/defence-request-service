class AddSolicitorTimeOfArrivalToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :solicitor_time_of_arrival, :datetime
  end
end
