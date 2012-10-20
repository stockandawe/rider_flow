class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.string :lat
      t.string :long
      t.integer :riders
      t.references :line

      t.timestamps
    end
  end
end
