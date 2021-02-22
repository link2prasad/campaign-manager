require 'test_helper'

class Api::V1::CampaignsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @campaign = campaigns(:one)
  end

  test "should show campaign" do
    get api_v1_campaign_url(@campaign), as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body)
    assert_equal @campaign.title, json_response['title']
  end

  test "should list campaigns" do
    get api_v1_campaigns_url(), as: :json
    assert_response :success
  end

  test "should create campaign, by a user" do
    assert_difference('Campaign.count') do
      post api_v1_campaigns_url,
           params: {campaign: {
               title: @campaign.title,
               purpose: @campaign.purpose,
               starts_on: @campaign.starts_on,
               ends_on: @campaign.ends_on
           }},
           headers: {Authorization: JsonWebToken.encode(user_id: @campaign.user_id)},
           as: :json
    end
  end

  test "should forbid campaign create, without a user" do
    assert_no_difference('Campaign.count') do
      post api_v1_campaigns_url,
           params: {campaign: {
               title: @campaign.title,
               purpose: @campaign.purpose,
               starts_on: @campaign.starts_on,
               ends_on: @campaign.ends_on
           }},
           as: :json
    end
  end

  test "should update campaign, if a owner" do
    patch api_v1_campaign_url(@campaign),
          params: {campaign: {title: @campaign.title}},
          headers: {Authorization: JsonWebToken.encode(user_id: @campaign.user_id)},
          as: :json
    assert_response :success
  end

  test "should not update campaign, if not owner" do
    patch api_v1_campaign_url(@campaign),
          params: {campaign: {title: @campaign.title}},
          headers: {Authorization: JsonWebToken.encode(user_id: users(:two).id)},
          as: :json
    assert_response :forbidden
  end

  test "should delete campaign, if a owner" do
    assert_difference('Campaign.count', -1) do
      delete api_v1_campaign_url(@campaign),
             headers: {Authorization: JsonWebToken.encode(user_id: @campaign.user_id)},
             as: :json
      assert_response :no_content
    end
  end

  test "should not delete campaign, if not owner" do
    assert_no_difference('Campaign.count') do
      delete api_v1_campaign_url(@campaign),
             headers: {Authorization: JsonWebToken.encode(user_id: users(:two).id)},
             as: :json
      assert_response :forbidden
    end
  end
end
