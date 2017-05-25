class CreateNodes < ActiveRecord::Migration[5.0]
  def change
    create_table :nodes do |t|
      t.string :ip
      t.string :port
      t.text :raw_response

      t.timestamps
    end
  end
end
