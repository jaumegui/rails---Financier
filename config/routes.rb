Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'matchs',     to: 'matchs#index'
  post 'matchs',    to: 'matchs#create'
  get 'matchs/:date', to: 'matchs#show', as: :match
  get 'matchs/new/:date', to: 'matchs#new', as: :new
  delete 'matchs/:id', to: 'matchs#delete'
  root 'matchs#index'
end
