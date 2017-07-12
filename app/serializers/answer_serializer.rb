class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :rating, :user_id, :created_at, :updated_at

  has_many :attachments
  has_many :comments

  def rating
    object.rating
  end
end
