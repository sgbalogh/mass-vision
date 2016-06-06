module ApplicationHelper

  def uhd_cookie?
    !cookies[:retina].blank?
  end

  def detect_uhd_display
    if params[:retina] == 'true'
      cookies[:retina] = true
    elsif params[:retina] == 'false'
      cookies[:retina] = false
    end
  end

end
