class Api::V1::CommentsController < ApplicationController
  before_action :check_login, only: %i[create]
  before_action :check_owner, only: %i[destroy]


  def create
    comment = @commentable.comments.new comment_params
    comment.user = current_user

    if comment.save
      render json: CommentSerializer.new(comment).serializable_hash, status: :created
    else
      render_error(comment.errors)
    end
  end


  def destroy
    @comment.destroy
    head 204
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def check_owner
    head :forbidden unless @comment.user_id == current_user&.id
  end
end