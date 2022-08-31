Rails.application.routes.draw do
  
  root "home#home"  

  devise_for :users,
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  resources :users
  resources :books
  resources :bought
  get "profile", to: "profile#data"
  
  post "buybook" , to: "home#buybook"

  # if wrong route given 
  get '*path', :to => 'application#routing_error'
  post '*path', :to => 'application#routing_error'

end
