class OrganizationsController < ApplicationController
  def create
    @organization = Organization.create(org_params)
    if @organization.save
      User.update(current_user.id, organization_id: organization.id)
      redirect_to overview_path
    else
      redirect_to welcome_path
    end
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:id])
    if @organization.update(org_params)
      redirect_to overview_path
    else
      render :edit
    end
  end

  def destroy
    Organization.destroy(params[:id])
    redirect_to welcome_path
  end

  private

  def org_params
    params.require(:organization).permit(:name, :hourly_rate)
  end
end
