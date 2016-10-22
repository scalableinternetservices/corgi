class AddTitleToEvents < ActiveRecord::Migration[5.0]
  def change
  	add_column :events, :title, :string
  	add_index :events, :title
  end
end
