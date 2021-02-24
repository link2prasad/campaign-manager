class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, :polymorphic => true
  validates :body,     presence: true


  include PgSearch::Model
  pg_search_scope :search_full_word,
                  :against => [:body],
                  :using => [:tsearch],
                  order_within_rank: "comments.created_at DESC"

  scope :for_discussion, ->(discussion_id) { where('commentable_id = ?', discussion_id) }
  scope :created_before, ->(created_before) { where('created_at < ?', created_before) }
  scope :created_by, ->(user_id) { where('user_id = ?', user_id) }
  scope :recent, lambda { order(updated_at: :desc) }


  def self.search(params = {})
    comments = params[:comment_ids].present? ? Comment.where(id: params[:comment_ids]) : Comment.all
    comments = comments.for_discussion(params[:discussion_id])

    comments = comments.search_full_word(params[:keyword]) if params[:keyword]
    comments = comments.created_before(params[:created_before]) if params[:created_before].present?
    comments = comments.created_by(params[:created_by]) if params[:created_by].present?
    comments = comments.recent if params[:recent].present?

    comments
  end
end
