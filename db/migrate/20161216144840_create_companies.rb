class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.references :size, foreign_key: true
      t.references :location, foreign_key: true
      t.string :site
      t.string :logo
      t.boolean :recrutmentagency
      t.string :description
      t.boolean :realy

      t.timestamps

    end
    add_index :companies, :name
    execute "CREATE INDEX companies_idx ON companies USING gin(to_tsvector('english', name || ' ' || site || ' '|| description));"
  end
end
