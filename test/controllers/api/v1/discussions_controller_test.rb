require 'test_helper'

class Api::V1::DiscussionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @discussion = discussions(:one)
  end

  test "should show discussion" do
    get api_v1_campaign_discussion_url({id:@discussion.id, campaign_id: @discussion.campaign_id}), as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)

    assert_equal @discussion.topic, json_response.dig(:data, :attributes, :topic)
    assert_equal @discussion.user.id.to_s, json_response.dig(:data, :relationships, :user, :data, :id)
    assert_equal @discussion.campaign.id.to_s, json_response.dig(:data, :relationships, :campaign, :data, :id)
    assert_equal @discussion.campaign.title, json_response.dig(:included, 1, :attributes, :title)
  end

  test "should create discussion, by a user" do
    assert_difference('Discussion.count') do
      post api_v1_campaign_discussions_url({campaign_id: @discussion.campaign_id}),
           params: {discussion: {
               topic: @discussion.topic,
               body: @discussion.body,
               campaign_id: @discussion.campaign_id
           }},
           headers: {Authorization: JsonWebToken.encode(user_id: @discussion.user_id)},
           as: :json
      assert_response :success
    end
  end

  test "should forbid discussion create, without a user" do
    assert_no_difference('Discussion.count') do
      post api_v1_campaign_discussions_url({campaign_id: @discussion.campaign_id}),
           params: {discussion: {
               topic: @discussion.topic,
               body: @discussion.body,
               campaign_id: @discussion.campaign_id
           }},
           as: :json
      assert_response :forbidden
    end
  end

  test "should forbid discussion create, without a campaign" do
    assert_no_difference('Discussion.count') do
      post api_v1_campaign_discussions_url({campaign_id: 0}),
           params: {discussion: {
               topic: @discussion.topic,
               body: @discussion.body
           }},
           headers: {Authorization: JsonWebToken.encode(user_id: @discussion.user_id)},
           as: :json
      assert_response :unprocessable_entity
    end
  end

  test "should update discussion, if a owner" do
    patch api_v1_campaign_discussion_url({id: @discussion.id, campaign_id: @discussion.campaign_id}),
          params: {discussion: {topic: @discussion.topic}},
          headers: {Authorization: JsonWebToken.encode(user_id: @discussion.user_id)},
          as: :json
    assert_response :success
  end

  test "should update discussion, if not a owner" do
    patch api_v1_campaign_discussion_url({id: @discussion.id, campaign_id: @discussion.campaign_id}),
          params: {discussion: {topic: @discussion.topic}},
          headers: {Authorization: JsonWebToken.encode(user_id: users(:two).id)},
          as: :json
    assert_response :forbidden
  end

  test "should delete discussion, if a owner" do
    assert_difference('Discussion.count', -1) do
      delete api_v1_campaign_discussion_url({id: @discussion.id, campaign_id: @discussion.campaign_id}),
             headers: {Authorization: JsonWebToken.encode(user_id: @discussion.user_id)},
             as: :json
      assert_response :no_content
    end
  end

  test "should not delete discussion, if not a owner" do
    assert_no_difference('Discussion.count') do
      delete api_v1_campaign_discussion_url({id: @discussion.id, campaign_id: @discussion.campaign_id}),
             headers: {Authorization: JsonWebToken.encode(user_id: users(:two).id)},
             as: :json
      assert_response :forbidden
    end
  end

  test "should list discussions" do
    get api_v1_discussions_url(), as: :json
    assert_response :success
  end

end
