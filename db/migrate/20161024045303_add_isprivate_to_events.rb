class AddIsprivateToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :isprivate, :boolean
  end
end
