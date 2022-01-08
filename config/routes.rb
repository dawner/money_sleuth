Rails.application.routes.draw do
  root 'categories#index'

  resources :transactions
  resources :transaction_batches
  resources :categories
  resources :banks
end
