class AddCaseAttributesToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :custody_address,                       :string
    add_column :defence_requests, :investigating_officer_name,            :string
    add_column :defence_requests, :investigating_officer_shoulder_number, :string
    add_column :defence_requests, :investigating_officer_contact_number,  :string
    add_column :defence_requests, :circumstances_of_arrest,               :text
  end
end
