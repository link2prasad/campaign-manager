class Tag < ApplicationRecord
  has_many :taggings, :dependent  => :destroy
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }, :uniqueness => {:case_sensitive => false}

  ### SCOPES:
  scope :most_used, ->(limit = 20) { order('taggings_count desc').limit(limit) }
  scope :least_used, ->(limit = 20) { order('taggings_count asc').limit(limit) }
  scope :normaliser, lambda { |value| value.to_s.upcase }

  def self.names_for_scope(scope)
    join_conditions = {:taggable_type => scope.name}
    if scope.is_a?(ActiveRecord::Relation)
      return Tag.none unless scope.current_scope.present?

      join_conditions[:taggable_id] = scope.select(:id)
    end

    joins(:taggings).where(Tagging.table_name => join_conditions).distinct.pluck(:name)
  end
end
