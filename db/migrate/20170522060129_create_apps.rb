class CreateApps < ActiveRecord::Migration[5.0]
  def change
    create_table :apps do |t|
      t.string :app_id
      t.integer :node_id
      t.text :raw_response

      t.timestamps
    end
  end
end
