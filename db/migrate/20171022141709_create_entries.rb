class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries do |t|
      t.string :uid, limit: 64, null: false, index: true
      t.string :device_id, limit: 64, null: false

      t.timestamps
    end
  end
end
