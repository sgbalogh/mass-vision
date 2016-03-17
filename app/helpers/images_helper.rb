module ImagesHelper

def has_location?
  @image.exif.key?('geo:lat') && @image.exif.key?('geo:long')
end

  def get_small(filename)
    "/iiif/#{filename}/full/400,/0/default.jpg"
  end


end
