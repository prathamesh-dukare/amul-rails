class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :excerpt, :slug, :status, :published_at, :created_at, :updated_at
  belongs_to :user
end
