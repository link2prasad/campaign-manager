require 'test_helper'

class Api::V1::TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @campaign = campaigns(:one)
    post api_v1_campaigns_url,
         params: {campaign: {
             title: @campaign.title,
             purpose: @campaign.purpose,
             starts_on: @campaign.starts_on,
             ends_on: @campaign.ends_on,
             tag_names: %w(melbourne sydney)
         }},
         headers: {Authorization: JsonWebToken.encode(user_id: @campaign.user_id)},
         as: :json

    assert_response :success
  end
  test "should list tags" do
    get api_v1_tags_url(), as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal Tag.count, json_response.dig(:data).to_a.length
  end

  test "should query tags for tagged times" do
    get api_v1_tags_url(tagged_times: 1), as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal 2, json_response.dig(:data).to_a.length
  end
end
