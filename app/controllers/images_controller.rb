class ImagesController < ApplicationController
  helper_method :has_loc?

  def singleimage
    @image = Image.find(params[:id])
    @owner = User.find(@image.user_id)
    if !@image.access.nil?
      unless @image.access['level'] == 1
        authenticate_user!
      end
    else
      authenticate_user!
    end
  end

  def inspect
    @image = Image.find(params[:id])
  end

  def index
    if user_signed_in?
      @images = Image.order(_id: :asc).page params[:page]
      @geojson = assemble_geojson(Image.order(_id: :asc).page params[:page])
    else
      @images = Image.where(access: {level: 1}).order(_id: :asc).page params[:page]
      @geojson = assemble_geojson(Image.where(access: {level: 1}).order(_id: :asc).page params[:page])
    end
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

  def has_loc?(img)
    if img.latitude && img.longitude
      true
    else
      false
    end
  end

  private

  def assemble_geojson(images)
    geojson_doc = {'type' => 'FeatureCollection', 'features' => []}
    images.each do |img|
      if has_loc?(img)
        img_hash = {'type' => 'Feature',
                    'geometry' => {
                        'type' => 'Point',
                        'coordinates' => [img.longitude, img.latitude]
                    },
                    'properties' => {'id' => img._id.to_s, 'jpg' => img.filename}
        }
        geojson_doc['features'] << img_hash
      end
    end
    return geojson_doc
  end

end
