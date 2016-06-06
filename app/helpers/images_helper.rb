module ImagesHelper

  def print_metadatum_row(image, exif_key, label)
    if image.exif[exif_key]
    "<tr><td>#{label}</td><td><code>#{image.exif[exif_key]}</code></td></tr>".html_safe
    end
  end

  def has_image?
    !@image.filename.blank?
  end

  def has_exif?
    !@image.exif.blank?
  end

  def retina_or_uhd?
    if cookies[:retina] == 'true'
      true
    else
      false
    end
  end

  def main_image_tag
    if retina_or_uhd?
      link_to image_tag(root_url + "iiif/#{@image.filename}/full/2280,/0/default.jpg", class: 'reg_img'), root_url + "images/#{@image._id}/inspect"
    else
      link_to image_tag(root_url + "iiif/#{@image.filename}/full/1140,/0/default.jpg", class: 'reg_img'), root_url + "images/#{@image._id}/inspect"
    end
  end

  def preview_image_href(filename)
    if retina_or_uhd?
      "/iiif/#{filename}/full/400,/0/default.jpg"
    else
      "/iiif/#{filename}/full/200,/0/default.jpg"
    end
  end

  def get_full_image(image, format)
    unless !has_image?
      root_url + 'iiif/' + image.filename + "/full/full/0/default.#{format}"
    end
  end
end
