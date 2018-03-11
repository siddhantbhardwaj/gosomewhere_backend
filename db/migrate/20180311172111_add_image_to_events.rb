class AddImageToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :image, :text
  end
end
