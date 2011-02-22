class CommentsController < ApplicationController
  def create
    
    
  end

  def destroy
    begin
      raise "Insufficient rights to delete comments." unless current_user.try(:admin?)

      Article.find( params[:article_id] ).comments.find( params[:id] ).destroy
      flash[:notice] = "Comment was deleted." 
    rescue
      flash[:alert] = "Comment could not be deleted."
    end
    
    redirect_to article_path(params[:article_id])
  end

end
