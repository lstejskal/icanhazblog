class ArticlesController < ApplicationController
  
  before_filter :admin_access_required, :except => [ :index, :show ]

  # GET /articles
  # TODO move admin listing to admin/article controller
  def index
    if admin?
      params[:show_hidden] ||= true
      params[:order] ||= "updated_at"

      @articles = Article.list(params)

      render :template => '/articles/admin_index'
    else      
      # hardcode certain params
      params[:show_hidden] = false
      params[:order] = "published_at"

      @articles = Article.list(params)

      render :action => :index
    end
  end

  # GET /articles/1
  def show
    @article = Article.find(params[:id])
      rescue raise(ActionController::RoutingError, "Sorry, that article doesn't exist.")

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /articles/new
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
      rescue raise(ActionController::RoutingError, "Sorry, that article doesn't exist.")
  end

  # POST /articles
  def create    
    # TODO move into model as chain-alias method?
    params[:article][:tags] = params[:article][:tags].to_s.split(/[\s,]+/)

    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to(@article, :notice => 'Article was successfully created.') }
      else
        flash.now[:alert] = 'Cannot create the article.'
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /articles/1
  def update
    @article = Article.find(params[:id])
    
    params[:article][:tags] = params[:article][:tags].to_s.split(/[\s,]+/)

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(@article, :notice => 'Article was successfully updated.') }
      else
        flash[:alert] = "Cannot update the article."
        format.html { render :action => "edit" }
      end
    end
  end

  def publish
    @article = Article.find(params[:id])
    @article.publish!
    redirect_to(articles_path, :notice => "Article [#{@article.title}] was published.")
  end
  
  def hide
    @article = Article.find(params[:id])
    @article.hide!
    redirect_to(articles_path, :notice => "Article [#{@article.title}] was hidden.")
  end

  # DELETE /articles/1
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
    end
  end
end
