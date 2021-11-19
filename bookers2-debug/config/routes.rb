Rails.application.routes.draw do
  devise_for :users

  resources :users,only: [:show,:index,:edit,:update]
  get 'home/about' => 'homes#about'

  resources :books do
  resources :book_comments, only: [:create, :destroy]
  resource :favorites, only: [:create, :destroy]
  end

root to: 'homes#top'

end
