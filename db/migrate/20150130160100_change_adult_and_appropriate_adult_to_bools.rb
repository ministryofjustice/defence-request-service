class ChangeAdultAndAppropriateAdultToBools < ActiveRecord::Migration
  def change
    remove_column :defence_requests, :adult
    remove_column :defence_requests, :appropriate_adult
    add_column :defence_requests, :adult, :bool
    add_column :defence_requests, :appropriate_adult, :bool, null: false, default: false
  end
end
