Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root 'homes#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end
  resources :users, only: [:index, :show]
  resources :chat_rooms, only: [:index, :create, :show] do
    collection do 
      get 'search'
    end
  end 
  resources :chat_messages, only: :create
  resources :items

  # 管理画面
  namespace :admin do
    root 'homes#index'
    resources :items
  end

  # api
  namespace :api, {format: 'json'} do
    resources :posts
    resources :chat_messages
  end
end
