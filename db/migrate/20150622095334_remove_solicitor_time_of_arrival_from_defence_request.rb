class RemoveSolicitorTimeOfArrivalFromDefenceRequest < ActiveRecord::Migration
  def change
    remove_column :defence_requests, :solicitor_time_of_arrival, :datetime
  end
end
