Rails.application.routes.draw do
  resources :publications
  get '/refresh', to: 'publications#refresh'
  get '/publications/:id/publish', to: 'publications#publish'
  get '/publications/:id/hide', to: 'publications#hide', path_name: 'hide'
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
