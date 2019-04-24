class CreateLectures < ActiveRecord::Migration[5.1]
  def change
    create_table :lectures do |t|
      t.string :subject, null: false, default: 'No subject'
      t.string :device_id, limit: 64, null: false
      t.datetime :dtstart, null: false
      t.datetime :dtstop
      t.references :user, foreign_key: true, null: false
      t.index :device_id

      t.timestamps
    end

    change_table :entries do |t|
      t.references :lecture, foreign_key: true
    end
  end
end
