class UploadsController < ApplicationController
  def index
    @uploads = Upload.all
  end

  def new
    @upload = Upload.new
  end

  def create
    @user = current_user
    @upload = @user.uploads.new(upload_params)

    if @upload.save
      flash[:success] = 'Image processing has begun –– this may take a few minutes.'
      redirect_to @user
      uploadProcess = UploadProcess.new(@upload, @user._id)
      uploadProcess.delay.move_upload_to_staging()
      uploadProcess.delay.decompress_upload()
      uploadProcess.delay.find_and_move_images()
      uploadProcess.delay.christen_images()
      uploadProcess.delay.assemble_metadata()
      uploadProcess.delay.move_to_image_storage()
      #uploadProcess.delay.cleanup()
      #uploadProcess.delay(run_at: 10.minutes.from_now).cleanup()

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
    params.require(:upload).permit(:attachment)
  end

end

