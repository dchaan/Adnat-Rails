class UsersController < ApplicationController
  skip_before_action :auth, :only[:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to welcome_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to overview_path
    else
      redirect_to welcome_path
    end
  end

  def join_org
    @organization = Organization.find(params[:id])
    User.update(current_user.id, organization_id: @organization.id)
    redirect_to overview_path
  end

  def leave_org
    User.update(current_user.id, organization_id: nil)
    redirect_to welcome_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
