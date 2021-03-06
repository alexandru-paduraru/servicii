Services::Application.routes.draw do

  resources :future_actions

resources :user, :only => [:login]
resources :admin, :only => [:signup] 

get '/logout', to: 'session#destroy_user', :as => "logout" 
get '/signup', to: 'session#signup', :as => "signup"
post '/signup', to: 'session#create', :as => "admin_create"
post '/login', to: 'session#login_user', :as => "login_user"
get '/login', to: 'session#login', :as =>"login"

#index for users
get '/salesman', to: 'salesman#index', :as => "salesman"
get '/accountant', to: 'accountant#index', :as => "accountant"
get '/collections', to: 'collector#index', :as => "collector"
get '/admin', to: 'admin#index', :as => "admin"
get '/users', to: 'user#index', :as => "users"

#create users
get '/salesman_new', to: 'salesman#new', :as =>"salesman_new"
post '/salesman_create', to: 'salesman#create', :as =>"salesman_create"

post '/admin', to: 'user#create', :as => "user_create"

#edit users
get '/employee/:id/edit', to: 'user#edit', :as => "user_edit"
patch '/employee/:id', to: 'user#update', :as => "user_update"
get '/employees', to: 'admin#employees_settings', :as => "employees_settings"

#view customers

get '/customers', to: 'salesman#index', :as => "customers"

get '/customers/search', to: 'salesman#search_ajax', :as => "customers_search"
#create customers
post '/customers', to: 'user#customer_create', :as => "customer_create"
get '/customers/new', to: 'user#customer_new', :as => "customer_new"

#delete customer
get '/delete/:customer_id', to: 'salesman#delete_customer', :as => "customer_delete"

#customer details
get '/customer_details/:customer_id', to: 'salesman#customer_details', :as => "customer_details"
get '/customer_details/:customer_id/edit', to: 'salesman#customer_edit', :as => "customer_edit"
patch '/customer_details/:customer_id', to: 'salesman#customer_update', :as => "customer_update"
post "/customer_details/send_sms", to: "salesman#send_sms"
get '/customers/save_call', to: "salesman#save_call", :as => "customer_save_call"
match "/next_status" => "invoices#next_status", via: [:get, :post]
match "/change_status" => "invoices#change_status", via: [:get, :post]

#customer import
post '/customers/import_export', to: 'user#customer_import', :as => "import_customers"
get '/customer_export', to: 'user#customer_export', :as => "export_customers"
get '/customers/import_export', to: 'user#customers_import_export', :as => "customers_import_export"

#invoice import
get '/invoices/import_export', to: 'accountant#invoices_import_export', :as => "invoices_import_export"
post '/invoice_import', to: 'accountant#invoice_import', :as => "import_invoices"
get '/invoice_export', to: 'accountant#invoice_export', :as => "export_invoices" 

#create/view invoice
get '/customers/:customer_id/invoices', to: 'salesman#customer_details', :as => "customer_invoices"
get '/customers/:customer_id/invoices/new', to: 'salesman#customer_new_invoice', :as => "customer_new_invoice"
post '/customers/:customer_id/invoices', to: 'accountant#invoice_create_test', :as => "customer_create_invoice"
get 'invoices/:id', to: 'invoices#show'

#create service for invoice
post '/customers/:customer_id/invoices/new/services/new', to: 'accountant#create_service', :as => "create_service_for_invoice"

#invoice details
get '/invoice_details/:invoice_number', to: 'accountant#invoice_details', :as => "invoice_details"
get '/invoice_pay/:invoice_id', to: 'accountant#invoice_pay', :as => "invoice_pay"
get '/invoices/search', to: 'accountant#search_ajax', :as => "invoice_search"
post "/invoice_details/send_sms", to: "accountant#send_sms", :as => "send_sms_invoice"
get '/collections/invoices/search', to: 'collector#search_ajax', :as => "collections_invoice_search"
get '/invoices/save_call', to: "accountant#save_call", :as => "invoice_save_call"
post '/invoices/undo', to: "invoices#undo"


#company details
get '/company_new', to: 'admin#company_new', :as => "company_new"
post '/company_new', to: 'admin#company_create', :as => "company_create"
get '/company/:id/edit', to: 'admin#company_edit', :as => "company_edit"
patch '/company/:id', to: 'admin#company_update', :as => "company_update"

#sending emails
get '/email', to: 'user#email', :as => "email"
get '/send_email/:customer_id', to: 'user#send_email', :as => "send_email"

#send to collector
get '/send_to_collector/:customer_id', to: 'user#send_to_collector', :as => "send_to_collector"


#for creating a note on an invoice
post '/invoice_details/:invoice_number/add_note', to: 'accountant#add_note', :as => "add_note"

post '/send_email_invoice/:invoice_id', to: 'accountant#send_email', :as => "send_email_invoice"


#invoice template

get '/invoice_template/:invoice_number', to: 'invoicetemplate#invoice_template', :as => "invoice_template"
get '/invoice_pdf/:invoice_number', to: 'invoicetemplate#invoice_pdf', :as => "invoice_pdf"
get 'invoice_xml/:invoice_number', to: 'invoicetemplate#invoice_xml', :as => "invoice_xml"
get 'invoice_csv/:invoice_number', to: 'invoicetemplate#invoice_csv', :as => "invoice_csv"
get 'invoice_xls/:invoice_number', to: 'invoicetemplate#invoice_xls', :as => "invoice_xls"

#adding undo to actions
post 'versions/revert', to: 'version#revert', :as => "revert_version"
post 'versions/revert_update', to: 'version#revert_update', :as => "revert_update_version"
post 'versions/archive_customer', to: 'version#archive_customer', :as => "archive_customer"
post 'versions/delete_user', to: 'version#delete_user', :as => "delete_user"

#for testing
get '/verifica', to: 'user#show', :as => "verifica"
root :to => 'session#home'

# invoice
post "/mark_payment", to: "invoices#mark_payment"


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
