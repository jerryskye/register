class CreateRegistrationTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :registration_tokens do |t|
      t.boolean :admin, null: false, default: false
      t.string :token, null: false, limit: 32

      t.timestamps
    end
    add_index :registration_tokens, :token, unique: true
  end
end
