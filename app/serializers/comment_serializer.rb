class CommentSerializer
  include JSONAPI::Serializer
  belongs_to  :user
  # belongs_to :commentable, :polymorphic => true
  attributes :body
end
