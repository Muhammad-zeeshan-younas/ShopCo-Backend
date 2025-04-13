Rails.application.routes.draw do

  get '/user', to: 'users#index'
  mount_devise_token_auth_for 'User', skip: [:omniauth_callbacks], at: 'auth', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :products, except: [:edit, :new] do
     get 'product-reviews', to: 'reviews#product_reviews'
  end
  resources :reviews, except: [:edit,]
end