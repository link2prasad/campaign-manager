class Api::V1::Discussions::CommentsController < ApplicationController
  before_action :set_commentable

  private

  def set_commentable
    @commentable = Discussion.find(params[:discussion_id])
  end
end