class Api::V1::CampaignsController < ApplicationController
  before_action :set_campaign, only: %i[show]

  #GET /campaigns/:id
  def show
    render json: @campaign
  end

  def index
    render json: Campaign.all
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:id])
  end
end
