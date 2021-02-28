class Api::V1::TagsController < ApplicationController
  def index
    tags = Tag.search(params)
    render json: TagSerializer.new(tags).serializable_hash
  end
end
