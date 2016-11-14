class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.references :user
      t.references :notified_by
      t.integer :event_id
      t.integer :notice_type
      t.boolean :read, default: false
      t.timestamps
    end

    add_foreign_key :notifications, :users
    add_foreign_key :notifications, :users, column: :notified_by_id
    add_index :notifications, [:user_id, :notified_by_id, :event_id]
  end
end
