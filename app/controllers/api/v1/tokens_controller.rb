class Api::V1::TokensController < ApplicationController
  def create

    if User.is_a_valid_email? user_params[:username]
      @user = User.find_by_email(user_params[:username])
    else
      @user = User.find_by_username(user_params[:username])
    end

    # same as if @user && @user.authenticate(user_params[:password])
    if @user&.authenticate(user_params[:password])
      render json: {
          token: JsonWebToken.encode(user_id: @user.id),
          email: @user.email
      }
    else
      head :unauthorized
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:email, :username, :password)
  end

end
