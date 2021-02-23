class Discussion < ApplicationRecord
  belongs_to :user
  belongs_to :campaign
  validates :topic,     presence: true


  include PgSearch::Model
  pg_search_scope :search_full_word,
                  :against => [:topic, :body],
                  :using => [:tsearch],
                  order_within_rank: "discussions.created_at DESC"
end
