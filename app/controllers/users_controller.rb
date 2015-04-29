class UsersController < ApplicationController
  def index
    @users = User.order(created_at: :asc)
  end

  def show
    find_user
  end

  def reset_password
    find_user
    @user.send_reset_password_instructions
    redirect_to users_path, notice: 'Password reset e-mail was sent to user'
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
