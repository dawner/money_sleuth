Rails.application.routes.draw do
  resources :transaction_batches
  resources :categories
  resources :banks
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
