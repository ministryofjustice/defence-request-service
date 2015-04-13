class AddTimeOfDetentionAuthorisedToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :time_of_detention_authorised, :datetime
  end
end
