class RelationshipsController < ApplicationController

  def create
    
    current_user.follow(params[:follow_id])
    redirect_back(fallback_location: root_path)
  end

  def destroy
    Relationship.find_by(follower_id: current_user.id, following_id: params[:id]).destroy
    redirect_back(fallback_location: root_path)
  end

end
