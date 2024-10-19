class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :address
      t.string :phone

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
