class CreateRegistrationTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :registration_tokens do |t|
      t.boolean :admin
      t.string :token, limit: 32

      t.timestamps
    end
    add_index :registration_tokens, :token, unique: true
  end
end
