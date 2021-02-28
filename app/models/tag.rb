class Tag < ApplicationRecord
  has_many :taggings, :dependent  => :destroy
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }, :uniqueness => {:case_sensitive => false}

  ### SCOPES:
  scope :most_used, ->(limit = 20) { order('taggings_count desc').limit(limit) }
  scope :least_used, ->(limit = 20) { order('taggings_count asc').limit(limit) }
  scope :tagged_times, ->(tag_count = 1)  { where('taggings_count >= ?', tag_count ).order('taggings_count desc')}

  def self.names_for_scope(scope)
    join_conditions = {:taggable_type => scope.name}
    if scope.is_a?(ActiveRecord::Relation)
      return Tag.none unless scope.current_scope.present?

      join_conditions[:taggable_id] = scope.select(:id)
    end

    joins(:taggings).where(Tagging.table_name => join_conditions).distinct.pluck(:name)
  end

  def self.search(params = {})
    tags = params[:tag_names].present? ? Tag.where(name: params[:tag_names]) : Tag.all

    tags = tags.names_for_scope(Campaign) if params[:tagged_to]=="campaign"
    tags = tags.names_for_scope(Campaign.where(:title => params[:campaign_title])) if params[:campaign_title].present?
    tags = tags.names_for_scope(Campaign.find(params[:campaign_id])) if params[:campaign_id].present?
    tags = tags.most_used if params[:most_used].present?
    tags = tags.least_used if params[:least_used].present?
    tags = tags.tagged_times(params[:tagged_times]) if params[:tagged_times].present?

    tags
  end
end
