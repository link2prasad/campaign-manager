class CreateCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :campaigns do |t|
      t.string :title, null: false
      t.string :purpose, null: false
      t.datetime :starts_on, null: false
      t.datetime :ends_on, null: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
