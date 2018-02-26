class SessionsController < ApplicationController
  before_action :load_current_user, only: [:destroy]

  def create
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

end
