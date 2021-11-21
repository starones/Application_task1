Rails.application.routes.draw do
  devise_for :users

  resources :users, except: :create do
    member do
    get :followings, :followers
    end
  end
  resources :relationships, only: [:create, :destroy]

  get 'home/about' => 'homes#about'

  resources :books do
  resources :book_comments, only: [:create, :destroy]
  resource :favorites, only: [:create, :destroy]
  end

root to: 'homes#top'

end
