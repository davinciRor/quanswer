class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_email, :created_at, :updated_at, :commentable_id, :commentable_type

  def user_email
    object.user_email
  end
end
