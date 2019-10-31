Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'homepages#index'
  
  resources :products do
    resources :reviews, only: [:new, :create]
  end
  
  resources :categories
  
  resources :merchants, except: [:new, :create, :index, :destroy] do
    resources :products, only: [:index] 
    resources :orders, only: [:index]
  end
  patch "/merchant/:id/orders", to: "orders#status_ship", as: "status_ship"
  
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#login", as: "auth_callback"
  delete "/logout", to: "merchants#logout", as: "logout"
  
  
  get "/orders/checkout", to: "orders#checkout", as: "checkout"
  
  resources :orders do
    resources :order_items
  end
  resources :order_items, only: [:create]
  
  
  get "/orders/:id/order_confirmation", to: "orders#order_confirmation", as: "orders_confirmation"
  post "/orders/purchase", to: "orders#purchase", as: "purchase"
end
