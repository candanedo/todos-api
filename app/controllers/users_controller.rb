class UsersController < ApplicationController
  before_action :find_user, only: :login

  def show
    render json: User.find(params[:id]).to_json
  end

  def create
    @user = User.new(permitted_params)

    if @user.save
      render json: @user.reload.to_json
    else
      render json: { error: true, message: @user.errors.full_messages }
    end
  end

  def login
    if @user.valid_password?(params[:user][:password])
      render json: { api_token: @user.api_token, error: false }
    else
      render json: { error: true, message: 'email or password is incorrect' }
    end
  end

  private

  def find_user
    @user = User.find_by(email: email_param)

    render json: {
      error: true, message: 'email or password is incorrect'
    } unless @user
  end

  def permitted_params
    params.require(:user).permit!
  end

  def email_param
    params.dig(:user)&.dig(:email)
  end
end
