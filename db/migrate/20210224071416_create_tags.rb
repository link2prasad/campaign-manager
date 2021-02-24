class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false, index: {unique: true}
      t.bigint :taggings_count, null: false, index: true, default: 0
      t.timestamps
    end
  end
end
