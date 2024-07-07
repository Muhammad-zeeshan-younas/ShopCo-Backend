Rails.application.routes.draw do
  resources :products, except: [:edit, :new]
  resources :reviews, except: [:edit, :new]
end