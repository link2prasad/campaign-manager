class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :taggable, polymorphic: true


  validates :taggable, :presence => true
  validates :tag,      :presence => true
  validates :tag_id,   :uniqueness => {
      :scope => %i[ taggable_id taggable_type ]
  }
end
