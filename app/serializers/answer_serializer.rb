class AnswerSerializer < ActiveModel::Serializer
  has_many :attachments

  attributes :id, :body, :rating, :user_id

  def rating
    object.rating
  end
end
