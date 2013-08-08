class AddFinishDateToBooks < ActiveRecord::Migration
  def change
    add_column :books, :finish_date, :datetime
  end
end
