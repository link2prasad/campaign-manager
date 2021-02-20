class Api::V1::UsersController < ApplicationController
  #GET /users/:id
  def show
    render json: User.find(params[:id])
  end

  #POST /users
  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render_error(user.errors)
    end
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :username)
  end
end
