require 'fileutils'
require 'find'
require 'json'

class UploadProcess
  def initialize(upload_object, submitting_user)
    @upload = upload_object
    @userid = submitting_user._id
    @upload_id = @upload._id
    @access_text = @upload.access
    @attachment_name = File.basename(@upload.attachment.to_s)
    @staging_path = "#{Rails.root}/user_uploads/staging_area/#{@upload_id}"
    @staging_zip_path = "#{@staging_path}/zip/#{@attachment_name}"
    @staging_unzip_path = "#{@staging_path}/unzip/"
    @staging_images_path = "#{@staging_path}/images/"
    @image_storage_path = ENV['IMAGE_STORAGE']
    @filepath = @upload.attachment.to_s
  end

  def start_processing
    self.delay.move_upload_to_staging
    self.delay.decompress_upload
    self.delay.find_and_move_images
    self.delay.christen_images
    self.delay.assemble_metadata
    self.delay.move_to_image_storage
    self.delay(run_at: 10.minutes.from_now).cleanup()
  end

  def move_upload_to_staging
    FileUtils.mkdir_p "#{@staging_path}/zip"
    FileUtils.cp_r(@filepath, "#{@staging_path}/zip")
  end

  def decompress_upload
    `unzip #{@staging_zip_path} -d #{@staging_unzip_path}`
  end

  def find_and_move_images
    FileUtils.mkdir_p @staging_images_path
    image_paths = collect_images(@staging_unzip_path)
    image_paths.each do |image|
      FileUtils.cp_r(image, @staging_images_path)
    end
  end

  def christen_images
    base = Time.now.hash.abs.to_s
    image_paths = collect_images(@staging_images_path)
    image_paths.each_with_index do |image, index|
      unless File.basename(image).start_with?('.')
        # All images in attachment will be associated by an identical key, and differentiated
        # by a sequentially numbered prefix (e.g. '3397029140685753256u1.jpg', '3397029140685753256u2.jpg' )
        FileUtils.mv image, @staging_images_path + base + 'u' + index.to_s + File.extname(image)
      end
    end
  end

  def assemble_metadata
    # This gathers all relevant metadata for each image, including that provided
    # from the Apache Tika scrape (photo EXIF data, filesystem metadata, etc.), and
    # 'access' level data

    image_paths = collect_images(@staging_images_path)
    metadata_objects = []
    image_paths.each do |image|
      unless File.basename(image).start_with?('.')
        # Ideally, this will be performed by some Tika binding for Ruby;
        # for the moment, we are stuck with using a system call
        tika = JSON.parse(`tika -j #{image}`)

        # Remove metadata values that are excessively long –– in particular,
        # this is necessary to remove lingering text representations of binaries
        # that may exist
        tika = tika.delete_if { |key, value| value.length >= 2000 }

        filename = File.basename(tika['resourceName'], File.extname(tika['resourceName']))
        extension = (File.extname(tika['resourceName'])).gsub('.','')
        metadata_hash = {filename: filename,
                         exif: tika,
                         file_format: extension,
                         user_id: @userid,
                         access: {level: translate_access}}
        metadata_objects << metadata_hash
      end
    end

    # Find user and batch insert all metadata objects, creating corresponding Mongo records
    user = User.find(@userid)
    user.images.collection.insert(metadata_objects)
  end

  def move_to_image_storage
    image_paths = collect_images(@staging_images_path)
    image_paths.each do |image|
      unless File.basename(image).start_with?('.')
        FileUtils.mv image, @image_storage_path + '/' + File.basename(image)
      end
    end
  end

  def image_formats
    # Regex to identify supported image extensions
    /.*\.(png|jpg|jpeg|tif|tiff)$/i
  end

  def collect_images(directory)
    paths = []
    Find.find(directory) do |path|
      paths << path if path =~ image_formats
    end
    paths
  end

  def cleanup
    FileUtils.remove_dir(@staging_path)
    FileUtils.rm(@filepath)
  end

  def translate_access
    case @access_text
      when 'Public (Global)'
        1
      when 'Public (Signed in)'
        2
      when 'Private'
        3
      else
        3
    end
  end

end