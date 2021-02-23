class CampaignSerializer
  include JSONAPI::Serializer
  belongs_to  :user
  has_one :discussion
  attributes :title, :purpose, :starts_on, :ends_on
end
