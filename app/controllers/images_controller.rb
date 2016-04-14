class ImagesController < ApplicationController
  before_action :authenticate_user!

  def singleimage
    @image = Image.find(params[:id])
    @owner = User.find(@image.user_id)
  end

  def inspect
    @image = Image.find(params[:id])
  end

  def index
    @images = Image.order(_id: :asc).page params[:page]
    @geojson = assemble_geojson(Image.order(_id: :asc).page params[:page])
  end

  def exif
    @image = Image.find(params[:id])
  end

  def delete
    @image = Image.find(params[:id])
    @owner = User.find(@image.user_id)

    if current_user == @owner
      @image.destroy
      flash[:success] = "Successfully deleted image"
      redirect_to images_path
    else
      flash[:danger] = "Unauthorized!"
      redirect_to images_path
    end
  end

  # Note, the has_loc? method below is duplicated from the version in the images_helper;
  # whenever one is modified, make sure to update the other one!
  def has_loc?(img)
    if !img.exif.blank?
      img.exif.key?('geo:lat') && img.exif.key?('geo:long')
    else
      false
    end
  end

  private

  def assemble_geojson(images)
    hash = {'type' => 'FeatureCollection', 'features' => []}
    images.each do |img|
      if has_loc?(img)
        img_hash = {'type' => 'Feature',
                    'geometry' => {
                        'type' => 'Point',
                        'coordinates' => [img.exif['geo:long'].to_f, img.exif['geo:lat'].to_f]
                    },
                    'properties' => {'id' => img._id.to_s, 'jpg' => img.filename}
        }
        hash['features'] << img_hash
      end
    end
    return hash
  end

end
