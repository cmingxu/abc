class AddHostnameToNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :hostname, :string
  end
end
