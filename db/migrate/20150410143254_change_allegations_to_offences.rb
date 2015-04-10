class ChangeAllegationsToOffences < ActiveRecord::Migration
  def change
    rename_column :defence_requests, :allegations, :offences
  end
end
