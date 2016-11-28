class RemoveInidices < ActiveRecord::Migration[5.0]
  def change
  	remove_index :users, :column => :email
  	remove_index :users, :column => :user_name
  	remove_index :events, :column => :title
  	remove_index :events, :column => :user_id
  	remove_index :comments, :column => :event_id
  	remove_index :comments, :column => :user_id
  	remove_index :invites, :column => :event_id
  	remove_index :invites, :column => :guest_id
  	remove_index :invites, :name => "index_invites_on_guest_id_and_event_id"
  	remove_index :notifications, :column => :user_id
  	remove_index :notifications, :column => :notified_by_id
  	remove_index :notifications, :name => "index_notifications_on_user_id_and_notified_by_id_and_event_id"
  	remove_index :relationships, :column => :follower_id
  	remove_index :relationships, :column => :followed_id
  	remove_index :relationships, :name => "index_relationships_on_follower_id_and_followed_id"
  end
end
