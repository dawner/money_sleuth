Rails.application.routes.draw do
  root 'expenses#index'

  # Core CRUD data models
  resources :transactions
  resources :transaction_batches, except: [:edit, :update]
  resources :categories
  resources :institutions
  resources :accounts
  resources :balance_entries

  # Summaries
  resources :expenses, only: :index
end
