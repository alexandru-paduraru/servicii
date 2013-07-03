Services::Application.routes.draw do

resources :user, :only => [:login]
resources :admin, :only => [:signup] 

get '/logout', to: 'session#destroy_user', :as => "logout" 
get '/signup', to: 'admin#signup', :as => "signup"
post '/login', to: 'session#login_user', :as => "login_user"
get '/login', to: 'session#login', :as =>"login"

#index for users
get '/salesman', to: 'salesman#index', :as => "salesman"
get '/accountant', to: 'accountant#index', :as => "accountant"
get '/collector', to: 'collector#index', :as => "collector"
get '/admin', to: 'admin#index', :as => "admin"
get '/users', to: 'user#index', :as => "users"
get '/employees/new', to: 'user#new', :as => "user_new"


#create users
get '/salesman_new', to: 'salesman#new', :as =>"salesman_new"
post '/salesman_create', to: 'salesman#create', :as =>"salesman_create"
post '/signup', to: 'admin#create', :as => "admin_create"
post '/employees', to: 'user#create', :as => "user_create"

#edit users
get '/employee/:id/edit', to: 'user#edit', :as => "user_edit"
patch '/employee/:id', to: 'user#update', :as => "user_update"


#create customers
post '/customer_create', to: 'user#customer_create', :as => "customer_create"
get '/customers/new', to: 'user#customer_new', :as => "customer_new"


#customer details
get '/customer_details/:customer_id', to: 'salesman#customer_details', :as => "customer_details"

#customer import
post '/customer_import', to: 'user#customer_import', :as => "import_customers"
get '/customer_export', to: 'user#customer_export', :as => "export_customers"
get '/customers/import_export', to: 'user#customers_import_export', :as => "customers_import_export"

#create invoice
get '/invoices/new', to: 'accountant#invoice_new', :as => "invoice_new"
post '/invoice_create', to: 'accountant#invoice_create', :as => "invoice_create"

#invoice details
get '/invoice_details/:invoice_id', to: 'accountant#invoice_details', :as => "invoice_details"

#company details
get '/company_new', to: 'admin#company_new', :as => "company_new"
post '/company_new', to: 'admin#company_create', :as => "company_create"
get '/company/:id/edit', to: 'admin#company_edit', :as => "company_edit"
patch '/company/:id', to: 'admin#company_update', :as => "company_update"

#sending emails
get '/email', to: 'user#email', :as => "email"

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
