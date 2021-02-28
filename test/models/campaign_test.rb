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

  test "should filter campaigns by title" do
    assert_equal 2, Campaign.search_full_word("content").count
  end

  test "should filter campaigns by title and sort them" do
    assert_equal [campaigns(:three), campaigns(:two)], Campaign.search_full_word("content").sort
  end

#   TODO: pending test cases
#   Campaign.search({campaign_ids: [41, 42, 43]})
#   Campaign.search({})
#   Campaign.search({keyword: "content"})
#   Campaign.search({keyword: "ut", campaign_ids: [35, 40], status: "completed"})
#   http://localhost:3000/api/v1/campaigns?campaign_ids%5B%5D=43&campaign_ids%5B%5D=41&campaign_ids%5B%5D=40

  test "should return tag names" do
    campaign = campaigns(:one)
    campaign.tags << Tag.create(:name => 'melbourne')

    assert_equal campaign.tag_names.to_a, ['melbourne']
  end

  test "should add tags via their names" do
    campaign = campaigns(:one)
    campaign.tag_names << 'melbourne'

    assert_equal campaign.tags.collect(&:name), ['melbourne']
  end

  test "should accept a completely new set of tags" do
    campaign = campaigns(:one)
    campaign.tag_names << 'melbourne'
    campaign.tag_names = %w(portland oregon)

    assert_equal campaign.tags.collect(&:name), %w(portland oregon)
  end

  test "should enumerate through tag names" do
    campaign = campaigns(:one)
    campaign.tag_names = %w(melbourne victoria)
    names = []

    campaign.tag_names.each do |name|
      names << name
    end

    assert_equal names, %w(melbourne victoria)
  end

  test "should not allow duplication of tags" do
    campaign = campaigns(:one)
    campaign.tag_names = %w(portland)

    campaign2 = campaigns(:two)
    campaign2.tag_names = %w(portland)

    assert_equal campaign.tag_ids, campaign2.tag_ids
  end

  test "should append tag names" do
    campaign = campaigns(:one)
    campaign.tag_names = %w(portland)
    campaign.tag_names += %w(melbourne victoria)

    assert_equal campaign.tags.collect(&:name),  %w(portland melbourne victoria)
  end

  test "should remove a single tag name" do
    campaign = campaigns(:one)
    campaign.tag_names = %w(portland oregon)
    campaign.tag_names.delete 'oregon'
    assert_equal campaign.tags.collect(&:name), ['portland']
  end

  test "should remove multiple tag names" do
    campaign = campaigns(:one)
    campaign.tag_names = %w(portland oregon ruby)

    campaign.tag_names -= %w(oregon ruby)
    assert_equal campaign.tags.collect(&:name), ['portland']

  end

  test "should remove associated tagging on tag removal" do
    campaign = campaigns(:one)
    campaign.tag_names = %w(portland oregon ruby)

    assert_difference('Tagging.count', -2) do
      campaign.tag_names -= %w(oregon ruby)
      assert_equal campaign.tags.collect(&:name), ['portland']
    end
  end
end
