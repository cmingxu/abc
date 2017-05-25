class AddHostinfoToNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :hostinfo, :text
  end
end
