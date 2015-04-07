class RemoveFeedbackFromDefenceRequest < ActiveRecord::Migration
  def up
    remove_column :defence_requests, :feedback
  end

  def down
    add_column :defence_requests, :feedback, :text
  end
end
