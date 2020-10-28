Rails.application.routes.draw do
  device_controllers = {
    registrations:  'front/devise_custom/registrations',
    sessions:       'front/devise_custom/sessions',
    passwords:      'front/devise_custom/passwords',
    confirmations:  'front/devise_custom/confirmations',
  }

  # 表画面
  scope module: :front do
    # トップ
    root 'homes#index'

    # devise
    devise_for :users, controllers: device_controllers, path: 'user', path_names: {
      sign_in:  'login',
      sign_out: 'logout',
    }
    devise_scope :user do
      post 'users/guest_sign_in', to: 'users/sessions#new_guest'
    end

    # 商品
    resources :items do
      resources :comments, only: [:create, :destroy]
    end

    # カテゴリ
    resources :categories, only: :show

    # マイページ
    resources :settings, only: :index
    namespace :settings do
      resources :notices, only: :index
    end
  end

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
