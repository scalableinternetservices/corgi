class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true, :index => false
      t.references :event, foreign_key: true, :index => false
      t.text :content

      t.timestamps
    end
  end
end
