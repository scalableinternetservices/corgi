class CreateLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :likes do |t|
      t.references :event, :index => false
      t.integer :user_id

      t.timestamps
    end
  end
end
