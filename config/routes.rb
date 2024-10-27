Rails.application.routes.draw do
    post 'users/sign_up', to: 'users/registrations#create'
  mount_devise_token_auth_for 'User', skip: [:omniauth_callbacks], at: 'user', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  
  
  resources :products, except: [:edit, :new]
  resources :reviews, except: [:edit, :new]
end