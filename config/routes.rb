Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    patch 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
  end
  root 'defence_requests#index'

  get 'defence_requests/refresh_dashboard' => 'defence_requests#refresh_dashboard'

  resources :defence_requests do
    collection do
      post 'solicitors_search'
    end
    member do
      put  'close'
    end
  end

end
