class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_email, :created_at

  def user_email
    object.user_email
  end
end
