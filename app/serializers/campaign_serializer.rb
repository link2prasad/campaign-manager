class CampaignSerializer
  include JSONAPI::Serializer
  attributes :title, :purpose, :starts_on, :ends_on
  belongs_to  :user
  has_one :discussion
end
