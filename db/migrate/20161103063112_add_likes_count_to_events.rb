class AddLikesCountToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :likes_count, :integer
  end
end
