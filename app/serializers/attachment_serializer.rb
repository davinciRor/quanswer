class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :file, :url

  def url
    object.file.url
  end
end
