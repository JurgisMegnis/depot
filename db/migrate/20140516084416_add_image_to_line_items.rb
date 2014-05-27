class AddImageToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :image_url, :string
  end
end
