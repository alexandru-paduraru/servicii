Services::Application.routes.draw do

resources :user, :only => [:login]
resources :admin, :only => [:signup] 

get '/logout', to: 'session#destroy_user', :as => "logout" 
get '/signup', to: 'admin#signup', :as => "signup"
post '/login_user', to: 'session#login_user', :as => "login_user"
get '/login', to: 'session#login', :as =>"login"

#index for users
get '/salesman', to: 'salesman#index', :as => "salesman"
get '/accountant', to: 'accountant#index', :as => "accountant"
get '/collector', to: 'collector#index', :as => "collector"
get '/admin', to: 'admin#index', :as => "admin"
get '/user', to: 'user#index', :as => "user"
get '/employee_new', to: 'user#new', :as => "employee_new"


#create users
get '/salesman_new', to: 'salesman#new', :as =>"salesman_new"
post '/salesman_create', to: 'salesman#create', :as =>"salesman_create"
post '/admin_create', to: 'admin#create', :as => "admin_create"
post '/employee_create', to: 'user#create', :as => "employee_create"

#create customers
post '/customer_create', to: 'user#customer_create', :as => "customer_create"

#customer details
get '/customer_details/:customer_id', to: 'salesman#customer_details', :as => "customer_details"

#invoice details
get '/invoice_details', to: 'accountant#invoice_details', :as => "invoice_details"

#for testing
get '/verifica', to: 'user#show', :as => "verifica"
root :to => 'session#login'













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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
