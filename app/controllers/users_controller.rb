class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @users = User.order(created_at: :asc)
  end

  def show
  end

  def reset_password
    @user.send_reset_password_instructions
    redirect_to users_path, notice: 'Password reset e-mail was sent to user'
  end

  def toggle_active
    @user.toggle! :is_active
    redirect_to @user
  end
end
