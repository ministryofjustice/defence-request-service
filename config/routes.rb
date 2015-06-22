Rails.application.routes.draw do
  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  namespace :custody_suite do
    resource :dashboard, only: [:show] do
      get :active, action: :show, id: :active
      get :closed, action: :show, id: :closed
      get :refresh_dashboard
    end
    root controller: :dashboards, action: :show
  end

  resources :defence_requests, except: [:index] do
    resource :solicitor_arrival_time, only: [:edit, :update]
    resource :interview_start_time, only: [:edit, :update]
    member do
      post "resend_details"
    end
  end

  resource :abort_defence_request, only: [:new, :create]
  resource :finish_defence_request, only: [:new, :create]
  resource :transition_defence_request, only: [:new, :create]

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"

  get "/status" => "status#index"
  get "/ping" => "status#ping"

  get "/help", controller: :static, action: :help, as: :help
  get "/maintenance", controller: :static, action: :maintenance, as: :maintenance
  get "/cookies", controller: :static, action: :cookies, as: :cookies
  get "/accessibility", controller: :static, action: :accessibility, as: :accessibility
  get "/terms", controller: :static, action: :terms, as: :terms
  get "/expired", controller: :static, action: :expired, as: :expired

  # TEMPORARY - for mockup purposes
  get "/solicitor_admin_dashboard", controller: :static, action: :solicitor_admin_dashboard, as: :solicitor_admin_dashboard
  get "/solicitor_admin_dr_detail_54", controller: :static, action: :solicitor_admin_dr_detail_54, as: :solicitor_admin_dr_detail_54
  get "/solicitor_admin_dr_detail_55", controller: :static, action: :solicitor_admin_dr_detail_55, as: :solicitor_admin_dr_detail_55
  get "/solicitor_admin_dr_detail_56", controller: :static, action: :solicitor_admin_dr_detail_56, as: :solicitor_admin_dr_detail_56
  get "/solicitor_admin_dr_detail_58", controller: :static, action: :solicitor_admin_dr_detail_58, as: :solicitor_admin_dr_detail_58
end
