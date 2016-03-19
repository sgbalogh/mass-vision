require 'carrierwave/mongoid'

class Upload
  include Mongoid::Document

  mount_uploader :attachment, AttachmentUploader

  belongs_to :user
end
