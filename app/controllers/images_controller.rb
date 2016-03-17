class ImagesController < ApplicationController

  def singleimage
    @image = Image.find(params[:id])
  end

  def inspect
    @image = Image.find(params[:id])
  end

  def index
    @images = Image.order(_id: :asc).page params[:page]
  end

end
