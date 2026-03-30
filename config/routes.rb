Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  get 'users/:id/profile', to: 'users#show', as: 'user_profile'

  namespace :parent_role do
    resources :children, only: [ :index, :create, :show, :destroy, :edit, :update ] do
      resource :pair_code, only: [ :update ]

      resources :routines, only: [ :index, :new, :create, :edit, :update, :destroy ]
    end

    root "routine_approvals#new"
    resources :routine_executions, only: [] do
      resources :routine_approvals, only: [ :create ]
    end
  end

  resource :child_session, only: [ :new, :create, :destroy ]

  namespace :child_role do
    root "dashboards#show"
    resources :routines, only: [ :index, :show ] do
      resources :routine_executions, only: [ :create ]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "tops#index"
end
