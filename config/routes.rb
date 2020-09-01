Rails.application.routes.draw do
  resources :lobbies

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  root 'welcome#index'
  get 'welcome/index'

  resources :rooms do
    collection do
      get 'prepare'
      post 'prepare'

      get 'battle'
      post 'battle'
    end
  end
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
