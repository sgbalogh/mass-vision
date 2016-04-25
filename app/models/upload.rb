require 'carrierwave/mongoid'

class Upload
  include Mongoid::Document

  mount_uploader :attachment, AttachmentUploader
  field :access, type: String

  belongs_to :user
end
