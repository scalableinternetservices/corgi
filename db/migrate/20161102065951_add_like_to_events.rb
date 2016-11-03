class AddLikeToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :like, :integer
  end
end
