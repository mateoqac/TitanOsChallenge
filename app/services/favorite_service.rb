class FavoriteService
  def self.get_favorite_channel_programs(user_id)
    UserFavorite.favorite_channel_programs_for_user(user_id)
                .map(&:favoritable)
  end

  def self.get_favorite_apps(user_id)
    UserFavorite.favorite_apps_for_user(user_id)
                .map(&:favoritable)
  end

  def self.add_app_favorite(user_id, app, position)
    # Actualizar posiciones si es necesario
    update_positions_for_new_favorite(user_id, position)

    # Crear o actualizar el favorito
    favorite = UserFavorite.find_or_initialize_by(
      user_id: user_id,
      favoritable: app
    )

    favorite.position = position
    favorite.save!
    favorite
  end

  def self.update_app_position(user_id, app_id, position)
    favorite = UserFavorite.find_by(
      user_id: user_id,
      favoritable_type: "StreamingApp",
      favoritable_id: app_id
    )

    return { success: false, errors: [ "Favorite not found" ] } unless favorite

    # Actualizar posiciones si es necesario
    update_positions_for_position_change(user_id, favorite.position, position)

    favorite.position = position

    if favorite.save
      { success: true, favorite: favorite }
    else
      { success: false, errors: favorite.errors.full_messages }
    end
  end

  private

  def self.update_positions_for_new_favorite(user_id, new_position)
    UserFavorite.favorite_apps_for_user(user_id)
                .where("position >= ?", new_position)
                .update_all("position = position + 1")
  end

  def self.update_positions_for_position_change(user_id, old_position, new_position)
    if old_position < new_position
      # Moviendo hacia abajo
      UserFavorite.favorite_apps_for_user(user_id)
                  .where("position > ? AND position <= ?", old_position, new_position)
                  .update_all("position = position - 1")
    else
      # Moviendo hacia arriba
      UserFavorite.favorite_apps_for_user(user_id)
                  .where("position >= ? AND position < ?", new_position, old_position)
                  .update_all("position = position + 1")
    end
  end
end
