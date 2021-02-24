class CreateTaggings < ActiveRecord::Migration[6.0]
  def change
    create_table :taggings do |t|
      t.belongs_to :tag, null: false, foreign_key: true
      t.belongs_to :taggable, polymorphic: true, index: true, null: false

      t.timestamps
    end
  end
end
