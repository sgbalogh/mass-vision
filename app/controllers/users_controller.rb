class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @images = @user.images.order(_id: :desc).take(5)
  end

  def image_index
    @user = User.find(params[:id])
    @images = @user.images.order(_id: :asc).page params[:page]
    @geojson = assemble_geojson(@images)
  end

  private

  def has_loc?(img)
    if !img.exif.blank?
      img.exif.key?('geo:lat') && img.exif.key?('geo:long')
    else
      false
    end
  end

  def assemble_geojson(images)
    hash = {'type' => 'FeatureCollection', 'features' => []}

    images.each do |img|
      if has_loc?(img)
        img_hash = {'type' => 'Feature',
                    'geometry' => {
                        'type' => 'Point',
                        'coordinates' => [img.exif['geo:long'].to_f, img.exif['geo:lat'].to_f]
                    },
                    'properties' => {'id' => img._id.to_s}
        }
        hash['features'] << img_hash
      end
    end
    return hash
  end

end
