class Campaign < ApplicationRecord

  belongs_to :user
  has_one :discussion, dependent: :destroy


  include Taggable
  has_many_tags

  validates :title,     presence: true
  validates :purpose,   presence: true
  validates_presence_of :starts_on, :ends_on
  validate :end_date_is_after_start_date

  include PgSearch::Model
  pg_search_scope :search_full_word,
                  :against => [:title, :purpose],
                  :using => [:tsearch],
                  order_within_rank: "campaigns.created_at DESC"

  scope :active, -> { where('starts_on < ?', Time.now )}
  scope :upcoming, -> { where('starts_on > ?', Time.now )}
  scope :completed, -> { where('ends_on < ?', Time.now )}
  scope :created_before, ->(time) { where('created_at < ?', time) }
  scope :recent, lambda { order(updated_at: :desc) }



  def self.search(params = {})
    campaigns = params[:campaign_ids].present? ? Campaign.where(id: params[:campaign_ids]) : Campaign.all

    campaigns = campaigns.search_full_word(params[:keyword]) if params[:keyword]
    campaigns = campaigns.active if params[:status]=="active"
    campaigns = campaigns.upcoming if params[:status]=="upcoming"
    campaigns = campaigns.completed if params[:status]=="completed"
    campaigns = campaigns.created_before(params[:created_before])  if params[:created_before].present?
    campaigns = campaigns.created_by(params[:created_by]) if params[:created_by].present?
    campaigns = campaigns.recent if params[:recent].present?

    campaigns
  end


  # def tag_names=(names)
  #   self.tags = names.split(/,\s*/).map do |name|
  #     Tag.find_or_create_by(name: name)
  #   end
  # end
  #
  # def tag_names
  #   tags.join(', ')
  # end

  private



  def end_date_is_after_start_date
    return if ends_on.blank? || starts_on.blank?
    if ends_on < starts_on
      errors.add(:ends_on, "cannot be before the start date")
    elsif ((ends_on - starts_on).to_i/1.day) > 90
      errors.add(:ends_on, "cannot be more than 3 months from the start date")
    end
  end

end
