Rails.application.routes.draw do
  resources :apps
  resources :nodes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  root "nodes#index"

  get 'welcome/index', as: :dashboard
  root 'welcome#index'
end
