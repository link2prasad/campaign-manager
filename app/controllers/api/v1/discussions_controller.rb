class Api::V1::DiscussionsController < ApplicationController
  before_action :set_discussion, only: %i[show update destroy]
  before_action :check_login, only: %i[create]
  before_action :check_owner, only: %i[update destroy]

  def show
    options = {include: [:user, :campaign]}
    render json: DiscussionSerializer.new(@discussion, options).serializable_hash
  end

  def index
    discussions = Discussion.all
    render json: DiscussionSerializer.new(discussions).serializable_hash
  end

  def create
    discussion = current_user.discussions.build(discussion_params)
    if discussion.save
      render json: DiscussionSerializer.new(discussion).serializable_hash, status: :created
    else
      render_error(discussion.errors)
    end
  end

  def update
    if @discussion.update(discussion_params)
      render json: DiscussionSerializer.new(@discussion).serializable_hash, status: :ok
    else
      render_error(@discussion.errors)
    end
  end

  def destroy
    @discussion.destroy
    head 204
  end

  private

  def discussion_params
    params.require(:discussion).permit(:topic, :body, :campaign_id)
  end

  def set_discussion
    @discussion = Discussion.find(params[:id])
  end

  def check_owner
    head :forbidden unless @discussion.user_id == current_user&.id
  end
end
