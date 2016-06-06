class FileController < ApplicationController
  def download
    @download = Download.new(params[:token], request.remote_ip)
    if @download.authorized?
      send_file @download.checkout_download
    else
      redirect_to '/'
    end
  end
end
