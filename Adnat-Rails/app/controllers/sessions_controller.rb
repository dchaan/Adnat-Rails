class SessionsController < ApplicationController
  skip_before_action :auth, only: [:new, :create]

  def new
    redirect_to root_path if session[:user_id]
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.organization_id == nil
        redirect_to welcome_path
      else
        redirect_to overview_path
      end
    else
      render :new
    end
  end

  def destroy
    session.destroy
    redirect_to login_path
  end

  def welcome
    if current_user.organization_id == nil
      @organization = Organization.new
    else
      redirect_to welcome_path
    end
  end

  def overview
    if current_user.organization_id != nil
      @organization= Organization.find(current_user.organization_id)
    else
      redirect_to overview_path
    end
  end
end
