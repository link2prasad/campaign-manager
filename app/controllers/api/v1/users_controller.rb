class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :check_owner, only: %i[update destroy]
  #GET /users/:id
  def show
    options = { include: [:campaigns] }
    render json: UserSerializer.new(@user, options).serializable_hash
  end

  #POST /users
  def create
    user = User.new(user_params)
    if user.save
      render json: UserSerializer.new(user).serializable_hash, status: :created
    else
      render_error(user.errors)
    end
  end

  #PATCH/PUT /users/:id
  def update
    if @user.update(user_params)
      render json: UserSerializer.new(@user).serializable_hash, status: :ok
    else
      render_error(@user.errors)
    end
  end

  def destroy
    @user.destroy
    head 204
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def check_owner
    head :forbidden unless @user.id == current_user&.id
  end

  def user_params
    params.require(:user).permit(:email, :password, :username)
  end
end
