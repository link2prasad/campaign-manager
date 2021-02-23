class DiscussionSerializer
  include JSONAPI::Serializer
  belongs_to  :user
  belongs_to  :campaign
  attributes :topic, :body
end
