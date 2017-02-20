class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :phone
      t.string :password
      t.boolean :responsible
      t.string :photo
      t.boolean :gender
      t.references :location, foreign_key: true

      t.timestamps
    end
    add_index :clients, :email

  end
end
