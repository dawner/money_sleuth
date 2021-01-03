Rails.application.routes.draw do
  root 'categories#index'

  resources :transaction_batches
  resources :categories
  resources :banks
end
