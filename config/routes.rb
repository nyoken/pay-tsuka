Rails.application.routes.draw do
  root 'home#index'
  get 'service', to: 'static#service'
  get 'contact', to: 'contact#new'
  post 'contact/confirm', to: 'contact#confirm'
  get 'contact/complete', to: 'contact#complete'
  post 'contact/complete', to: 'contact#create', as: 'create_contact'

  devise_for :users, controllers: { registrations: 'users/registrations',
                                    sessions: 'users/sessions' }
  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    post 'login', to: 'devise/sessions#create'
    delete 'logout', to: 'devise/sessions#destroy'
    get 'register', to: 'devise/registrations#new'
    post 'register', to: 'devise/registrations#create'
  end
  resources :shops, only: %i(index show)
end
