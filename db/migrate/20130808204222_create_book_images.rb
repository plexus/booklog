class CreateBookImages < ActiveRecord::Migration
  def self.up
    create_table :book_images do |t|
      t.integer    :book_id
      t.string     :style
      t.binary     :file_contents
    end
  end

  def self.down
    drop_table :book_images
  end
end
