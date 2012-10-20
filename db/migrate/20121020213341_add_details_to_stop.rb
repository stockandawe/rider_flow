class AddDetailsToStop < ActiveRecord::Migration
  def change
    add_column :stops, :tag, :string
    add_column :stops, :title, :string
    add_column :stops, :short_title, :string
    add_column :stops, :stop_id, :integer
  end
end
