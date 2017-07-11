class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :rating, :user_id, :created_at, :updated_at

  has_many :attachments

  def rating
    object.rating
  end
end
