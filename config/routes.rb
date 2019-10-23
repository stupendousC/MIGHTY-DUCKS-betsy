Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'homepages#index'
  
  resources :products
  
  resources :merchants
  get "/login", to: "merchants#login_form", as: "login"
  post "/login", to: "merchants#login"
  post "/logout", to: "merchants#logout", as: "logout"
  
  get "/orders/view_cart", to: "orders#view_cart", as: "view_cart"
  get "/orders/checkout", to: "orders#checkout", as: "checkout"
  
  ### did NOT make a route for reviews b/c we can just embed both all the reviews AND the new review form in the products/:id show page?
  
end
