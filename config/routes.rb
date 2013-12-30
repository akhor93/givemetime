GiveMeTime::Application.routes.draw do
  get "password_resets/new"
  get '/oauth2authorize' => 'calendar#oauth2authorize', as: :oauth2authorize
  get '/oauth2callback' => 'calendar#oauth2callback', as: :oauth2callback
  get '/load_google_events' => 'calendar#load_google_events', as: :load_google_events

  resource :session, :only => [:new, :create, :destroy]
  resources :users, :only => [:new, :create, :show, :edit, :update]
  resource :admin, :only => :show
  resource :home, :only => :index
  resources :password_resets, :only => [:create, :edit, :update]

  resources :calendar, :only => :index
  resources :events, :only => [:new, :create, :show, :edit, :update, :destroy]
  resources :todos, :only => [:new, :create, :show, :edit, :update, :destroy] do
    member do
      post 'to_event'
    end
  end
  resources :activities, :only => [:new, :create, :show, :edit, :update, :destroy] do
    member do
      post 'to_event'
    end
  end
  
  #miscellaneous routes for prettier urls
  get '/logout' => 'sessions#destroy', as: :signout

  root :to => 'home#index'

  #*************************************************************

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
