Rails.application.routes.draw do
  root 'events#index'
  # get 'events/:username', to: 'events#show'
  get 'events/all', to: 'events#all'
  # resources :users, only: [:index]
  # resources :events, only: [:index, :show]
end
