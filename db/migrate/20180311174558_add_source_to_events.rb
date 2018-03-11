class AddSourceToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :source, :string
  end
end
