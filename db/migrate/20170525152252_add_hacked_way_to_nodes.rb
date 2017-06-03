class AddHackedWayToNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :hacked_way, :string
  end
end
