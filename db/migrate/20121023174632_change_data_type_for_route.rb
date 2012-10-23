class ChangeDataTypeForRoute < ActiveRecord::Migration
  def up
    change_column :lines, :route, :text, :limit => nil
  end

  def down
  end
end
