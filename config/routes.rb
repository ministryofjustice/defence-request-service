Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    patch 'users/:id' => 'devise/registrations#update', as: 'user_registration'
  end
  root 'defence_requests#index'

  get 'defence_requests/refresh_dashboard' => 'defence_requests#refresh_dashboard'

  resources :defence_requests do
    collection do
      post 'solicitors_search'
    end
    member do
      get 'close'
      patch 'close' => 'defence_requests#feedback', as: 'close_feedback'
      put 'queue'
      put 'acknowledge'
      patch 'accept' => 'defence_requests#accept'
      post 'resend_details'
      patch 'solicitor_time_of_arrival' => 'defence_requests#solicitor_time_of_arrival', as: 'solicitor_time_of_arrival'
    end
  end

  get '/status' => 'status#index'
  get '/help', controller: :static, action: :help, as: :help
  get '/maintenance', controller: :static, action: :maintenance, as: :maintenance
  get '/cookies', controller: :static, action: :cookies, as: :cookies
  get '/accessibility', controller: :static, action: :accessibility, as: :accessibility
  get '/terms', controller: :static, action: :terms, as: :terms
  get '/expired', controller: :static, action: :expired, as: :expired
end
