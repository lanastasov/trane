class ProfilesController < ApplicationController
  before_filter :require_user

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes params[:user]
      redirect_to dashboard_path, :notice => 'Профилът ви е обновен'
    else
      render :edit
    end
  end
end
