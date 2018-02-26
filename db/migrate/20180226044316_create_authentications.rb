class CreateAuthentications < ActiveRecord::Migration[5.1]
  def change
    create_table :authentications do |t|
      t.string :auth_token
      t.integer :user_id
      t.timestamps
    end
  end
end
