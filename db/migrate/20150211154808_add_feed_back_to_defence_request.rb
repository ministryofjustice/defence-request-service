class AddFeedBackToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :feedback, :text
  end
end
