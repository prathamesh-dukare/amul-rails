class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { in: 3..200 }
  validates :content, presence: true, length: { minimum: 10 }
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }
  validates :status, inclusion: { in: %w[draft published archived] }
  validates :excerpt, length: { maximum: 300 }, allow_blank: true

  before_validation :generate_slug, if: :title_changed?
  before_save :set_published_at, if: :status_changed?

  scope :published, -> { where(status: 'published') }
  scope :draft, -> { where(status: 'draft') }
  scope :archived, -> { where(status: 'archived') }
  scope :recent, -> { order(created_at: :desc) }

  private

  def generate_slug
    self.slug = title.parameterize if title.present?
  end

  def set_published_at
    self.published_at = Time.current if status == 'published' && published_at.nil?
  end
end
