require 'tag_names'

module Taggable
  extend ActiveSupport::Concern

  included do
    def self.has_many_tags
      has_many :taggings, :class_name => 'Tagging',
               :as => :taggable, :dependent => :destroy
      has_many :tags,     :class_name => 'Tag',
               :through => :taggings
    end
  end



  def tag_names
    @tag_names ||= TagNames.new self
  end

  def tag_names=(names)
    if names.is_a?(TagNames)
      @tag_names = names
    else
      @tag_names = TagNames.new_with_names self, names
    end
  end

end
