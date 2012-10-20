class AddDetailsToBus < ActiveRecord::Migration
  def change
    add_column :buses, :bus_id, :integer
    add_column :buses, :dir_tag, :string
  end
end
