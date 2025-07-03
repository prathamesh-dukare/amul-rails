class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :first_name, :last_name, :bio, :avatar_url, :created_at, :updated_at, :posts_count

  def posts_count
    object.posts.count
  end
end
