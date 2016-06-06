class UploadsController < ApplicationController
  before_action :authenticate_user!

  def index
    @uploads = Upload.all
  end

  def new
    @upload = Upload.new
    @user = current_user
  end

  def create
    @user = current_user
    @upload = @user.uploads.new(upload_params)

    if @upload.save
      flash[:success] = 'Image processing has begun –– this may take a few minutes.'
      redirect_to @user
      uploadProcess = UploadProcess.new(@upload, @user)
      uploadProcess.start_processing
    else
      render "new"
    end
  end

  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
    redirect_to uploads_path, notice:  "The upload #{@upload.name} has been deleted."
  end

  private
  def upload_params
    params.require(:upload).permit(:attachment, :access)
  end

end

