class AddAttributesToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :solicitor_name, :string
    add_column :defence_requests, :solicitor_firm, :string
    add_column :defence_requests, :scheme, :string
    add_column :defence_requests, :phone_number, :string
    add_column :defence_requests, :detainee_surname, :string
    add_column :defence_requests, :detainee_first_name, :string
    add_column :defence_requests, :gender, :string
    add_column :defence_requests, :adult, :string
    add_column :defence_requests, :date_of_birth, :datetime
    add_column :defence_requests, :appropriate_adult, :string
    add_column :defence_requests, :custody_number, :string
    add_column :defence_requests, :allegations, :string
    add_column :defence_requests, :time_of_arrival, :datetime
    add_column :defence_requests, :comments, :text
  end
end
