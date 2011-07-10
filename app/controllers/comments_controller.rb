class CommentsController < ApplicationController
  def create
    begin
      @article = Article.find(params[:article_id])
      @comment = Comment.new(params[:comment])
      
      if current_user
        @comment.user_nickname = current_user.nickname
        @comment.user_location = nil
      # check if nickname isn't already registered
      else
        if User.where(:nickname => @comment.user_nickname).first
          @comment.errors.add(:nickname, "cannot be used. It is already used by registered user.")
          raise "validation error"
        end
      end
      
      unless verify_recaptcha(:model => @comment, :message => "Captcha is invalid")
        raise "captcha error"
      end

      raise "validation error" unless @comment.valid?

      @article.comments << @comment
      
      flash.delete(:recaptcha_error)
      flash[:notice] = "Comment was added."
      redirect_to article_path(params[:article_id])
    rescue
      # don't display default recaptcha errors
      flash.delete(:recaptcha_error)

      # TO DO: display errors in comment form
      flash[:alert] = "Comment could not be added." + @comment.errors.full_messages.join(" ")
      render :template => "articles/show"
    end
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
