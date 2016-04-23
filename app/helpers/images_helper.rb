module ImagesHelper

  def has_location?
    @image.exif.key?('geo:lat') && @image.exif.key?('geo:long') rescue false
  end

  def has_loc?(img)
    if !img.exif.blank?
      img.exif.key?('geo:lat') && img.exif.key?('geo:long')
    else
      false
    end
  end

  def has_image?
    !@image.filename.blank?
  end

  def has_exif?
    !@image.exif.blank?
  end

  def get_small(filename)
    "/iiif/#{filename}/full/400,/0/default.jpg"
  end

  def get_full_jpg(image)
    if !image.filename.blank?
      root_url + 'iiif/' + image.filename + '/full/full/0/default.jpg'
    else
      nil
    end

  end

  def get_full_png(image)
    if !image.filename.blank?
    root_url + 'iiif/' + image.filename + '/full/full/0/default.png'
    else
      nil
    end

  end



end
