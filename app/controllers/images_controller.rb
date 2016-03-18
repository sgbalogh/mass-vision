class ImagesController < ApplicationController
  before_action :authenticate_user!

  def singleimage
    @image = Image.find(params[:id])
  end

  def inspect
    @image = Image.find(params[:id])
  end

  def index
    @images = Image.order(_id: :asc).page params[:page]
    @geojson = assemble_geojson(Image.order(_id: :asc).page params[:page])
  end

  private

  def has_loc?(img)
    img.exif.key?('geo:lat') && @image.exif.key?('geo:long') rescue true
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
                    'properties' => {'id' => img._id.to_s }
        }
        hash['features'] << img_hash
      end
    end
    return hash
  end


end
