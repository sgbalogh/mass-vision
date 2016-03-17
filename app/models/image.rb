class Image
  include Mongoid::Document
  field :title, type: String
  field :description, type: String
  field :access, type: Hash
  field :exif, type: Hash
  field :filename, type: String
  field :file_format, type: String

end
