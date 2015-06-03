class RemoveDefaultValuesFromRadioButtonsOnDefenceRequest < ActiveRecord::Migration
  def up
    change_column_default :defence_requests, :appropriate_adult, nil
    change_column_default :defence_requests, :fit_for_interview, nil
    change_column_default :defence_requests, :interpreter_required, nil
  end

  def down
    change_column_default :defence_requests, :appropriate_adult, false
    change_column_default :defence_requests, :fit_for_interview, true
    change_column_default :defence_requests, :interpreter_required, false
  end
end
