class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :body, :title, :created_at, :updated_at
  has_many :answers
  has_many :comments
  has_many :attachments
end
