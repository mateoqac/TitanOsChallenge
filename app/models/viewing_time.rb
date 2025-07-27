class ViewingTime < ApplicationRecord
  belongs_to :content

  validates :user_id, presence: true
  validates :time_watched, presence: true, numericality: { greater_than: 0 }
  validates :viewed_at, presence: true

  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_content, ->(content_id) { where(content: content_id) }

  def self.total_time_watched_for_user_and_content(user_id, content_id)
    by_user(user_id).by_content(content_id).sum(:time_watched)
  end
end
