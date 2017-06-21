class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :rating, :user_id

  has_many :attachments

  def rating
    object.rating
  end
end
