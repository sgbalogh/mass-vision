class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @images = @user.images.order(_id: :desc).take(10)
  end
end
