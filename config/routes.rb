Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',      
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
  }
  
  resources :products, except: [:edit, :new]
  resources :reviews, except: [:edit, :new]
end