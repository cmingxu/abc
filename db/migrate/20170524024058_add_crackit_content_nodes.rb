class AddCrackitContentNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :crackit_content, :text
  end
end
