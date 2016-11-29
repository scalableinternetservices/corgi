class AddInvitesCountToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :invites_count, :integer
  end
end
