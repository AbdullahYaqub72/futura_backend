Rails.application.routes.draw do
  get "dashboard/transaction_totals_by_type"
  get "dashboard/sales_summary"
  get "dashboard/recent_transactions"
  get "permissions/index"
  get "roles/index"
  get "roles/show"
  get "roles/assign"
  get "roles/remove"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  post "auth/register", to: "auth#register"
  post "auth/login", to: "auth#login"
  get "/auth/google", to: "auth#google_login"  
  get "/auth/callback", to: "auth#google_callback"

  resources :users, only: [:index, :show, :create, :update, :destroy]
  get '/users/by_supabase_id/:supabase_id', to: 'users#find_by_supabase_id'
  get '/users/id_by_supabase_id/:supabase_id', to: 'users#find_id_by_supabase_id'
  get 'users/:id/roles_permissions', to: 'users#roles_permissions'

  # Customers API
  resources :customers, only: [:index, :show, :create, :update, :destroy]

  # Products API
  resources :products, only: [:index, :show, :create, :update, :destroy]

  # Product Categories API
  resources :product_categories, only: [:index, :show, :create, :update, :destroy]

  # Transactions API
  resources :transactions, only: [:index, :show, :create, :update, :destroy]

  resources :transaction_items

  resources :businesses

  resources :roles, only: [:index, :show, :create, :edit, :update] do
    post 'assign', on: :collection
    post 'remove', on: :collection
  end

  resources :permissions, only: [:index]


  # # Mpesa Transactions API
  # resources :mpesa_transactions, only: [:index, :show, :create, :update, :destroy]

  # # Inventory Logs API
  resources :inventory_logs, only: [:index, :show, :create, :update, :destroy]

  # Reports API
  get 'reports/daily', to: 'reports#daily'
  get 'reports/monthly', to: 'reports#monthly'
  get 'reports/yearly', to: 'reports#yearly'
  get '/reports/yearly_by_category', to: 'reports#yearly_by_category'
  get '/reports/grouped_by_category_and_payment_method', to: 'reports#grouped_by_category_and_payment_method'
  get '/reports/daily_by_category', to: 'reports#daily_by_category'
  get '/reports/daily_transactions_summary', to: 'reports#daily_transactions_summary'
  get '/reports/inventory_valuation', to: 'reports#inventory_valuation'
  get '/reports/stock_availability_trend', to: 'reports#stock_availability_trend'
  get '/reports/monthly_stock_by_category', to: 'reports#monthly_stock_by_category'

  get '/dashboard/transaction_totals_by_type', to: 'dashboard#transaction_totals_by_type'
  get '/dashboard/sales_summary', to: 'dashboard#sales_summary'
  get '/dashboard/recent_transactions', to: 'dashboard#recent_transactions'

  # Defines the root path route ("/")
  # root "posts#index"
end
