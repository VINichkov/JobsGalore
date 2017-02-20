class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :postcode
      t.string :suburb
      t.string :state

      t.timestamps
    end

    execute "CREATE INDEX locations_idx ON locations USING gin(to_tsvector('english', suburb || ' ' || state|| ' '|| postcode));"
  end
end
