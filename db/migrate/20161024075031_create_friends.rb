class CreateFriends < ActiveRecord::Migration[5.0]
  def change
    create_table :friends do |t|
      t.integer :friend_a
      t.integer :friend_b

      t.timestamps

    end
  end
end
