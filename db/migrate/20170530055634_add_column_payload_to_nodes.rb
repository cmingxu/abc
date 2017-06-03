class AddColumnPayloadToNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :payload, :string
  end
end
