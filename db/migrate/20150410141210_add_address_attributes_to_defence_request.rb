class AddAddressAttributesToDefenceRequest < ActiveRecord::Migration
  def change
    add_column :defence_requests, :house_name,  :string
    add_column :defence_requests, :address_1,   :string
    add_column :defence_requests, :address_2,   :string
    add_column :defence_requests, :city,        :string
    add_column :defence_requests, :county,      :string
    add_column :defence_requests, :postcode,    :string
  end
end
