class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true

  mount_uploader :file, FileUploader

  def url
    self.file.url
  end
end
