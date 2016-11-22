class CreateExists < ActiveRecord::Migration[5.0]
  def change
    create_table :exists do |t|
      t.integer :mutex

      t.timestamps
    end
    add_index :exists, :mutex, unique: true
  end
end
