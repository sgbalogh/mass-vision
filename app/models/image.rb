class Image
  include Mongoid::Document
  field :title, type: String
  field :description, type: String
  field :access, type: Hash
  field :exif, type: Hash
  field :filename, type: String
  field :file_format, type: String

  def has_location?
    if latitude && longitude
      true
    else
      false
    end
  end

  def has_exif?
    !self.exif.blank?
  end

  def latitude
    if self.exif['geo:lat']
      self.exif['geo:lat'].to_f
    end
  end

  def longitude
    if self.exif['geo:long']
      self.exif['geo:long'].to_f
    end
  end

  belongs_to :user
end
