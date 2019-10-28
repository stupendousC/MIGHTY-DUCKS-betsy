Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'homepages#index'
  
  resources :products do
    resources :reviews, only: [:new, :create]
  end
  
  resources :categories
  
  resources :merchants, except: [:new, :create] do
    resources :products, only: [:index] 
    resources :orders, only: [:index]
  end
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#login", as: "auth_callback"
  delete "/logout", to: "merchants#logout", as: "logout"
  # not sure if we need a merchants#index page, why would they want to see what other merchants are out there?
  # merchant's own merchants/:id show page will have all the links to add/edit/delete products? and links to all relevant placed orders?
  get "/orders/checkout", to: "orders#checkout", as: "checkout"

  resources :orders do
    resources :order_items
  end
  resources :order_items, only: [:create]
  
  get "/orders/view_cart", to: "orders#view_cart", as: "view_cart"
  post "/orders/purchase", to: "orders#purchase", as: "purchase"
  ### did NOT make a route for reviews b/c we can just embed both all the reviews AND the new review form in the products/:id show page?
  
end
