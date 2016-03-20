require 'fileutils'
require 'find'
require 'json'

class UploadProcess
  def initialize(upload, userid)
    @upload = upload
    @upload_id = upload._id
    @attachment_name = File.basename(upload.attachment.to_s)
    @staging_path = "#{Rails.root}/user_uploads/staging_area/#{@upload_id}"
    @staging_zip_path = "#{Rails.root}/user_uploads/staging_area/#{@upload_id}/zip/#{@attachment_name}"
    @staging_unzip_path = "#{Rails.root}/user_uploads/staging_area/#{@upload_id}/unzip/"
    @staging_images_path = "#{Rails.root}/user_uploads/staging_area/#{@upload_id}/images/"
    @image_storage_path = "#{Rails.root}/image_storage/"
    @filepath = upload.attachment.to_s
    @userid = userid
  end

  def move_upload_to_staging
    FileUtils.mkdir_p "#{Rails.root}/user_uploads/staging_area/#{@upload_id}/zip"
    FileUtils.cp_r(@filepath, "#{Rails.root}/user_uploads/staging_area/#{@upload_id}/zip")
  end

  def decompress_upload
    `unzip #{@staging_zip_path} -d #{@staging_unzip_path}`
  end

  def find_and_move_images
    FileUtils.mkdir_p @staging_images_path
    image_paths = []
    Find.find(@staging_unzip_path) do |path|
      image_paths << path if path =~ /.*\.(png|jpg|jpeg|tif|tiff)$/i
    end
    image_paths.each do |image|
      FileUtils.cp_r(image, @staging_images_path)
    end
  end

  def christen_images
    base = Time.now.hash.abs.to_s
    image_paths = []
    Find.find(@staging_images_path) do |path|
      image_paths << path if path =~ /.*\.(png|jpg|jpeg|tif|tiff)$/i
    end
    counter = 1
    image_paths.each do |image|
      unless File.basename(image).start_with?('.')
        FileUtils.mv image, @staging_images_path + base + 'u' + counter.to_s + File.extname(image)
        counter = counter + 1
      end
    end
  end

  def assemble_metadata
    image_paths = []
    Find.find(@staging_images_path) do |path|
      image_paths << path if path =~ /.*\.(png|jpg|jpeg|tif|tiff)$/i
    end

    puts image_paths

    upload_meta_array = []
    image_paths.each do |image|
      unless File.basename(image).start_with?('.')
        tika = JSON.parse(`tika -j #{image}`)

        # Get rid of any EXIF values that are super long
        tika = tika.delete_if { |key, value| value.length >= 2000 }

        filename = File.basename(tika['resourceName'], File.extname(tika['resourceName']))
        extension = (File.extname(tika['resourceName'])).gsub(".", "")
        metadata_hash = {filename: filename, exif: tika, file_format: extension, user_id: @userid}
        upload_meta_array << metadata_hash
      end
    end

    user = User.find(@userid)
    user.images.collection.insert(upload_meta_array)
  end

  def move_to_image_storage
    image_paths = []
    Find.find(@staging_images_path) do |path|
      image_paths << path if path =~ /.*\.(png|jpg|jpeg|tif|tiff)$/i
    end

    image_paths.each do |image|
      unless File.basename(image).start_with?('.')
        FileUtils.mv image, @image_storage_path + File.basename(image)
      end
    end
  end

  def cleanup
    FileUtils.remove_dir(@staging_path)
    FileUtils.rm(@filepath)
  end

end