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
end
