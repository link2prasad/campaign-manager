class CampaignSerializer
  include JSONAPI::Serializer
  belongs_to  :user
  has_one :discussion
  # has_many  :tags
  # has_many  :taggings
  attributes :title, :purpose, :starts_on, :ends_on
end
