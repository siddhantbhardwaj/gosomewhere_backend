class AddAddressToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :address, :text
  end
end
