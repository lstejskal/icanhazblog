class ArticlesController < ApplicationController

  # GET /articles
  def index
    @articles = Article.list(params)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /articles/1
  def show
    @article = Article.find(params[:id])

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
  end

  # POST /articles
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to(@article, :notice => 'Article was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /articles/1
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(@article, :notice => 'Article was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
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
