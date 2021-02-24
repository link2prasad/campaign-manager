class Tag < ApplicationRecord
  has_many :taggings, :dependent  => :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }, :uniqueness => {:case_sensitive => false}

  scope :by_weight, lambda { order(taggings_count: :desc) }
  scope :normaliser, lambda { |value| value.to_s.upcase }

  def remove_unused
    @connection = ActiveRecord::Base.connection
    result =  @connection.exec_query('DELETE FROM tags WHERE id NOT IN (SELECT DISTINCT tag_id FROM taggings)')
    result.each do |r|
      pp r
    end
  end

end
