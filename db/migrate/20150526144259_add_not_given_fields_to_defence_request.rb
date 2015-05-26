class AddNotGivenFieldsToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :detainee_name_not_given, :boolean, default: false
    add_column :defence_requests, :detainee_address_not_given, :boolean, default: false
    add_column :defence_requests, :date_of_birth_not_given, :boolean, default: false
  end
end
