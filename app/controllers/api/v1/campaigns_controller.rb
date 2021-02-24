class Api::V1::CampaignsController < ApplicationController
  before_action :set_campaign, only: %i[show update destroy]
  before_action :check_login, only: %i[create]
  before_action :check_owner, only: %i[update destroy]

  #GET /campaigns/:id
  def show
    options = {include: [:user]}
    render json: CampaignSerializer.new(@campaign, options).serializable_hash
  end

  def index
    campaigns = Campaign.search(params)
    render json: CampaignSerializer.new(campaigns).serializable_hash
  end

  def create
    campaign = current_user.campaigns.build(campaign_params)
    if campaign.save
      render json: CampaignSerializer.new(campaign).serializable_hash, status: :created
    else
      render_error(campaign.errors)
    end
  end

  def update
    if @campaign.update(campaign_params)
      render json: CampaignSerializer.new(@campaign).serializable_hash, status: :ok
    else
      render_error(@campaign.errors)
    end
  end

  def destroy
    @campaign.destroy
    head 204
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :purpose, :starts_on, :ends_on, :tag_names)
  end

  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  def check_owner
    head :forbidden unless @campaign.user_id == current_user&.id
  end
end
