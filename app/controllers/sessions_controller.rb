class SessionsController < ApplicationController
  before_action :load_current_user, only: [:destroy]

  def create
    check_if_user_already_logged_in()
    @user = User.where(email: params[:email]).first
    if @user && @user.authenticate(params[:password])
      @auth = @user.save_token
      render 'users/authenticated'
    else
      render_unauthorized('Invalid Credentials')
    end
  end

  def destroy
    if @authentication
      @authentication.destroy
      render json: {}, status: :ok
    else
      render_unauthorized('Unauthorized')
    end
  end

  private
  def check_if_user_already_logged_in
    auth_token = request.headers['X-Go-Auth']
    if auth_token
      @authentication = Authentication.where(auth_token: auth_token).first
      @authentication.destroy if @authentication
    end
  end

end
