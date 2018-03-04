class UsersController < ApplicationController
    
  def create
    @user = User.new(user_params)
    if @user.save
      @auth = @user.save_token
      render 'users/authenticated'
    else
      render_errors(@user)
    end
  end

  def current
    load_current_user
    @user = @current_user
    render 'users/show'
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
end
