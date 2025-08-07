class Api::V1::FavoritesController < ApplicationController
  def channel_programs
    user_id = params.require(:user_id)
    favorites = FavoriteService.get_favorite_channel_programs(user_id)
    render json: favorites, scope: { user_id: user_id }
  end

  def apps
    user_id = params.require(:user_id)
    favorites = FavoriteService.get_favorite_apps(user_id)
    render json: favorites
  end

  def create_app_favorite
    user_id = params.require(:user_id)
    app_id = params.require(:app_id)
    position = params.require(:position)

    app = StreamingApp.find_by(id: app_id)

    return render json: { error: "App not found" }, status: :not_found unless app

    favorite = FavoriteService.add_app_favorite(user_id, app, position)
    if favorite
      render json:  favorite
    else
      render json: { error: favorite.errors } , status: :unprocessable_entity
    end
    # begin

    # rescue ActiveRecord::RecordNotFound
    #   return render json: { error: "App not found" }, status: :unprocessable_entity
    # end
  end
end
