Rails.application.routes.draw do
  root 'expenses#index'

  # Core CRUD data models
  resources :transactions
  resources :transaction_batches
  resources :categories
  resources :banks

  # Summaries
  resources :expenses, only: :index
end
