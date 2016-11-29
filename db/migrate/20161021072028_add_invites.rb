class AddInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :invites do |t|
      t.integer :guest_id
      t.integer :event_id

      t.timestamps
    end
    add_index :invites, :guest_id
    add_index :invites, :event_id
    # add_index :invites, [:guest_id, :event_id], unique: true
  end
end
