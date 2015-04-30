class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @user = User.new
    @users = User.order(created_at: :asc)
  end

  def show
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'User details updated'
      redirect_to can?(:manage, User) ? @user : profile_path
    else
      render can?(:manage, User) ? :show : show_profile
    end
  end

  def create
    @user = User.new(user_params.merge(password: SecureRandom.hex))
    if @user.save
      redirect_to @user, notice: 'User created'
    else
      @users = User.order(created_at: :asc)
      render :index
    end
  end

  def show_profile
    @user = current_user
    render :show
  end

  def reset_password
    @user.send_reset_password_instructions
    redirect_to users_path, notice: 'Password reset e-mail was sent to user'
  end

  def toggle_active
    @user.toggle! :is_active
    redirect_to @user
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end
end
