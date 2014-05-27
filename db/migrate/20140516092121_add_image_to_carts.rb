class AddImageToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :image_url, :string
  end
end
