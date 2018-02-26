class AddSrcIdToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :src_id, :string
  end
end
