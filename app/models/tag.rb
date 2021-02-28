class Tag < ApplicationRecord
  has_many :taggings, :dependent  => :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }, :uniqueness => {:case_sensitive => false}

  ### SCOPES:
  scope :most_used, ->(limit = 20) { order('taggings_count desc').limit(limit) }
  scope :least_used, ->(limit = 20) { order('taggings_count asc').limit(limit) }
  scope :normaliser, lambda { |value| value.to_s.upcase }

  def remove_unused
    # @connection = ActiveRecord::Base.connection
    result =  Tag.connection.exec_query('DELETE FROM tags WHERE id NOT IN (SELECT DISTINCT tag_id FROM taggings)')
    result.each do |r|
      pp r
    end
  end

end
