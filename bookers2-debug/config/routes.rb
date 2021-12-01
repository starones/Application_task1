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

  # 検索機能
  get 'search' => 'searches#search'

  # DM機能
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show]

end
