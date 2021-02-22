require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  test "should have a valid title" do
    campaign = campaigns(:one)
    campaign.title = nil
    assert_not campaign.valid?
  end

  test "should have a valid purpose" do
    campaign = campaigns(:one)
    campaign.purpose = nil
    assert_not campaign.valid?
  end

  test "should have a valid user" do
    campaign = campaigns(:one)
    campaign.user = nil
    assert_not campaign.valid?
  end

  test "should have a valid start date" do
    campaign = campaigns(:one)
    campaign.starts_on = nil
    assert_not campaign.valid?
  end

  test "should have a valid end date" do
    campaign = campaigns(:one)
    campaign.ends_on = nil
    assert_not campaign.valid?
  end

  test "end date cant be more than 3 months from  start date" do
    campaign = campaigns(:one)
    campaign.starts_on = "2021-02-21 16:16:05"
    campaign.ends_on = "2021-05-23 16:16:05"
    assert_not campaign.valid?
  end

end
