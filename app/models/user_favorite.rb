class UserFavorite < ApplicationRecord
  belongs_to :favoritable, polymorphic: true

  validates :user_id, presence: true
  validates :favoritable, presence: true
  validates :position, presence: true, if: -> { favoritable_type == 'StreamingApp' }
  validates :user_id, uniqueness: { scope: [:favoritable_type, :favoritable_id] }

  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_type, ->(favoritable_type) { where(favoritable_type: favoritable_type) }
  scope :ordered_by_position, -> { order(:position) }

  def self.favorite_apps_for_user(user_id)
    by_user(user_id).by_type('StreamingApp').ordered_by_position
  end

  def self.favorite_channel_programs_for_user(user_id)
    by_user(user_id).by_type('Content').select { |fav| fav.favoritable&.type == 'ChannelProgram' }
  end
end
