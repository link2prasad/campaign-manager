class Api::V1::Discussions::CommentsController < Api::V1::CommentsController
  before_action :set_commentable


  private

  def set_commentable
    @commentable = Discussion.find(params[:discussion_id])
  end

end