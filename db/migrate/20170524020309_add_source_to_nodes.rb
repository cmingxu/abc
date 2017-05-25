class AddSourceToNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :source, :string
  end
end
