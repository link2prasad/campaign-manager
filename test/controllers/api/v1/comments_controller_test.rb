require 'test_helper'

class Api::V1::CommentsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @comment = comments(:one)
    @campaign = Discussion.find(@comment.commentable_id).campaign
  end

  test "user can add comment to a discussion" do
    assert_difference('Comment.count') do
      post api_v1_campaign_discussion_comments_url({
                                                       campaign_id: @campaign.id,
                                                       discussion_id: @comment.commentable_id}),
           params: {comment: {
               body: @comment.body,
               commentable_id: @comment.commentable_id,
               commentable_type: @comment.commentable_type
           }},
           headers: {Authorization: JsonWebToken.encode(user_id: @comment.user_id)},
           as: :json
      assert_response :success
    end
  end

  test "should forbid comment add without a user" do
    assert_no_difference('Comment.count') do
      post api_v1_campaign_discussion_comments_url({
                                                       campaign_id: @campaign.id,
                                                       discussion_id: @comment.commentable_id}),
           params: {comment: {
               body: @comment.body,
               commentable_id: @comment.commentable_id,
               commentable_type: @comment.commentable_type
           }},
           # headers: {Authorization: JsonWebToken.encode(user_id: @comment.user_id)},
           as: :json
      assert_response :forbidden
    end
  end

  test "should forbid comment add without a discussion" do
    assert_no_difference('Comment.count') do
      post api_v1_campaign_discussion_comments_url({
                                                       campaign_id: @campaign.id,
                                                       discussion_id: 0}),
           params: {comment: {
               body: @comment.body,
               commentable_id: @comment.commentable_id,
               commentable_type: @comment.commentable_type
           }},
           headers: {Authorization: JsonWebToken.encode(user_id: @comment.user_id)},
           as: :json
      assert_response :unprocessable_entity
    end
  end
end
