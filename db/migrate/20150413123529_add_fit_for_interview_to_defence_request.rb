class AddFitForInterviewToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :fit_for_interview, :bool, null: false, default: true
  end
end
