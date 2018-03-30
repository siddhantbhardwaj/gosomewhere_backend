Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/users' => 'users#create'
  get '/users/current' => 'users#current'
  
  post '/signin' => 'sessions#create'
  get '/signout' => 'sessions#destroy'
  
  resources :events, only: [:index, :show] do
    resources :comments
    
    post '/change_attending', to: 'events#change_attending'
  end
end
