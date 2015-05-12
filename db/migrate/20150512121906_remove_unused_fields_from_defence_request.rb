class RemoveUnusedFieldsFromDefenceRequest < ActiveRecord::Migration
  def change
    remove_column :defence_requests, :solicitor_name, :string
    remove_column :defence_requests, :solicitor_firm, :string
    remove_column :defence_requests, :scheme, :string
    remove_column :defence_requests, :phone_number, :string

    remove_column :defence_requests, :custody_number, :string
    remove_column :defence_requests, :custody_address, :string
  end
end
