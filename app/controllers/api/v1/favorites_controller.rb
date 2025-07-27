class Api::V1::FavoritesController < ApplicationController
  def channel_programs
    user_id = params[:user_id]

    unless user_id.present?
      return render json: { error: 'User ID is required' }, status: :bad_request
    end

    favorites = FavoriteService.get_favorite_channel_programs(user_id)
    render json: favorites
  end

  def apps
    user_id = params[:user_id]

    unless user_id.present?
      return render json: { error: 'User ID is required' }, status: :bad_request
    end

    favorites = FavoriteService.get_favorite_apps(user_id)
    render json: favorites
  end

  def create_app_favorite
    user_id = params[:user_id]
    app_id = params[:app_id]
    position = params[:position]

    unless user_id.present? && app_id.present? && position.present?
      return render json: { error: 'User ID, App ID and Position are required' }, status: :bad_request
    end

    begin
      result = FavoriteService.add_app_favorite(user_id, app_id, position)
    rescue ActiveRecord::RecordNotFound
      return render json: { error: 'App not found' }, status: :unprocessable_entity
    end

    if result[:success]
      render json: result[:favorite]
    else
      render json: { error: result[:errors] }, status: :unprocessable_entity
    end
  end
end
