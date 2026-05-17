class CreateUrls < ActiveRecord::Migration[8.1]
  def change
    create_table :urls do |t|
      t.string :original_url, null: false
      t.string :short_code, null: false
      t.integer :clicks_count, default: 0, null: false

      t.timestamps
    end
    add_index :urls, :short_code, unique: true
  end
end
