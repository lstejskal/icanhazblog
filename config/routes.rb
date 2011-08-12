Icanhazblog::Application.routes.draw do

  constraints(:year => /\d{4}/, :month => /\d{2}/) do
    # PS: articles/yyyy/mm/id == articles/id
    get 'articles/:year/:month/:id' => 'articles#show'
    # articles/yyyyy(/mm) -> all articles for given year (and month)
    get 'articles/:year(/:month)' => 'articles#index'
  end

  resources :articles do
    member do
      post :hide
      post :publish
    end
    
    resources :comments # TODO restrict with :only
  end

  get "log_in" => "sessions#new", :as => "log_in"
  get "log_out" => "sessions#destroy", :as => "log_out"

  resources :sessions, :except => [ :edit ] # TODO restrict with :only

  root :to => "articles#index"

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  #
  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
