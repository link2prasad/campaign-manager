class UserSerializer
  include JSONAPI::Serializer
  has_many :campaigns
  attributes :email
end
