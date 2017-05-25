class AddKeysToNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :keys, :text
  end
end
