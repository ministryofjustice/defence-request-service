class AddUnfitForInterviewReasonToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :unfit_for_interview_reason, :text
  end
end
