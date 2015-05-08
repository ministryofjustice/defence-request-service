Rails.application.routes.draw do
  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)
  root "dashboards#show"

  resource :dashboard, only: [:show]
  get "/dashboards/closed", to: "dashboards#closed", as: "dashboard_closed"
  get "/refresh_dashboard", to: "dashboards#refresh_dashboard"

  resources :defence_requests, except: [:index] do
    resource :solicitor_arrival_time, only: [:edit, :update]
    member do
      post "resend_details"
    end
  end

  resource :abort_defence_request, only: [:new, :create]
  resource :finish_defence_request, only: [:new, :create]
  resource :solicitor_search, only: [:create]
  resource :transition_defence_request, only: [:new, :create]

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"

  get "/status" => "status#index"
  get "/help", controller: :static, action: :help, as: :help
  get "/maintenance", controller: :static, action: :maintenance, as: :maintenance
  get "/cookies", controller: :static, action: :cookies, as: :cookies
  get "/accessibility", controller: :static, action: :accessibility, as: :accessibility
  get "/terms", controller: :static, action: :terms, as: :terms
  get "/expired", controller: :static, action: :expired, as: :expired
end
