module ImagesHelper

def has_location?
  @image.exif.key?('geo:lat') && @image.exif.key?('geo:long')
end

  def get_small(filename)
    "/iiif/#{filename}/full/400,/0/default.jpg"
  end

  def get_full_jpg(image)
    root_url + 'iiif/' + image.filename + '/full/full/0/default.jpg'
  end

def get_full_png(image)
  root_url + 'iiif/' + image.filename + '/full/full/0/default.png'
end

end
