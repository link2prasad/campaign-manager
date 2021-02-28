require 'test_helper'

class Api::V1::CampaignsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @campaign = campaigns(:one)
  end

  test "should show campaign" do
    get api_v1_campaign_url(@campaign), as: :json
    assert_response :success

    # json_response = JSON.parse(self.response.body)
    # assert_equal @campaign.title, json_response['data']['attributes']['title']

    json_response = JSON.parse(self.response.body, symbolize_names: true)

    assert_equal @campaign.title, json_response.dig(:data, :attributes, :title)
    assert_equal @campaign.user.id.to_s, json_response.dig(:data, :relationships, :user, :data, :id)
    assert_equal @campaign.user.email, json_response.dig(:included, 0, :attributes, :email)
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
  test "should create new tags" do
    assert_difference('Tag.count', 2) do
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

  end

  test "should returns tag names" do
    post api_v1_campaigns_url,
         params: {campaign: {
             title: @campaign.title,
             purpose: @campaign.purpose,
             starts_on: @campaign.starts_on,
             ends_on: @campaign.ends_on,
             tag_names: ["melbourne"]
         }},
         headers: {Authorization: JsonWebToken.encode(user_id: @campaign.user_id)},
         as: :json

    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal ['melbourne'], json_response.dig(:data, :attributes, :tag_names).to_a
  end



  test "should accept completely new set of tags" do
    post api_v1_campaigns_url,
         params: {campaign: {
             title: @campaign.title,
             purpose: @campaign.purpose,
             starts_on: @campaign.starts_on,
             ends_on: @campaign.ends_on,
             tag_names: ["melbourne"]
         }},
         headers: {Authorization: JsonWebToken.encode(user_id: @campaign.user_id)},
         as: :json

    assert_response :success

    patch api_v1_campaign_url(@campaign),
          params: {campaign: {tag_names: %w(portland oregon)}},
          headers: {Authorization: JsonWebToken.encode(user_id: @campaign.user_id)},
          as: :json

    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal %w(portland oregon), json_response.dig(:data, :attributes, :tag_names).to_a
  end


  test "should not allow duplication of tags" do
    assert_difference('Tag.count', 1) do
      post api_v1_campaigns_url,
           params: {campaign: {
               title: @campaign.title,
               purpose: @campaign.purpose,
               starts_on: @campaign.starts_on,
               ends_on: @campaign.ends_on,
               tag_names: %w(melbourne melbourne)
           }},
           headers: {Authorization: JsonWebToken.encode(user_id: @campaign.user_id)},
           as: :json

      assert_response :success
    end
  end

  test "should append tag names" do
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

    assert_difference('Tag.count', 2) do
      json_response = JSON.parse(self.response.body, symbolize_names: true)
      tag_names = json_response.dig(:data, :attributes, :tag_names).to_a
      tag_names += %w(portland oregon)

      patch api_v1_campaign_url(@campaign),
            params: {campaign: {tag_names: tag_names}},
            headers: {Authorization: JsonWebToken.encode(user_id: @campaign.user_id)},
            as: :json

      assert_response :success

    end
    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal %w(melbourne sydney portland oregon), json_response.dig(:data, :attributes, :tag_names).to_a
  end

end
