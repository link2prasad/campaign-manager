class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :commentable, polymorphic: true, index: true, null: false

      t.timestamps
    end
  end
end
