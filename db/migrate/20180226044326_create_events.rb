class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
      t.integer :attendees
      t.text :address
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end
end
