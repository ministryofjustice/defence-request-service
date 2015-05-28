class ChangeAddressFieldsOnDefenceRequest < ActiveRecord::Migration
  def change
    remove_column :defence_requests, :house_name, :string
    remove_column :defence_requests, :address_1, :string
    remove_column :defence_requests, :address_2, :string
    remove_column :defence_requests, :city, :string
    remove_column :defence_requests, :county, :string
    remove_column :defence_requests, :postcode, :string
    add_column :defence_requests, :detainee_address, :string
  end
end
