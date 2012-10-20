class CreateBuses < ActiveRecord::Migration
  def change
    create_table :buses do |t|
      t.string :lat
      t.string :long
      t.integer :riders
      t.references :line

      t.timestamps
    end
  end
end
