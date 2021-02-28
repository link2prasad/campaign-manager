class Tagging < ApplicationRecord

  belongs_to :tag, counter_cache: true
  belongs_to :taggable, polymorphic: true
  after_destroy :remove_unused_tags

  validates :taggable, :presence => true
  validates :tag,      :presence => true
  validates :tag_id,   :uniqueness => {
      :scope => %i[ taggable_id taggable_type ]
  }

  scope :owned_by, ->(owner) { where(taggable: owner) }
  scope :not_owned, -> { where(taggable_id: nil, taggable_type: nil) }

  private

  def remove_unused_tags
    tag.destroy if tag.reload.taggings_count.zero?
  end
end
