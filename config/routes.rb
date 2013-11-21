# encoding: UTF-8
AppFab::Application.routes.draw do

  get "welcome/index"
  get 'welcome/fail'
  match 'page/:page' => 'welcome#static_page', :as => :static_page, via: :get

  resources :notifications
  resources :accounts
  resources :ideas do
    resources :vettings,    only: [:create, :destroy]
    resources :votes,       only: [:create, :destroy]
    resources :attachments, only: [:create, :destroy, :show]
  end

  resources :comments do
    resources :votes, only: [:create, :destroy]
    resources :attachments, only: [:create, :destroy, :show]
  end

  resources :attachments, only: [:destroy, :show]

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    resources :roles, only: [:create, :destroy], controller: :user_roles
  end

  namespace :user do
    resources :bookmarks, only: [:create, :destroy]
    resources :invites, only: [:create]
  end

  devise_for :logins, :path => :session, :controllers => {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resource :session, only:[:update]
  resource :dashboard, only:[:show]


  namespace :admin do
    unless Rails.env.production?
      resources :email_previews, only:[:index]
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
