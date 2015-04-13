class AddTimeOfArrestToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :time_of_arrest, :datetime
  end
end
