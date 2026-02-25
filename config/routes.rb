Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :parent_role do
    resources :children, only: [:index, :create, :show, :destroy] do
      resource :pair_code, only: [:update] # 再発行用（child単位）

      resources :routines, only: [ :index, :new, :create, :edit, :update ]
    end

    root "routine_approvals#new"
    resources :routine_executions, only: [] do
      resources :routine_approvals, only: [:create]
    end
  end

  resource :child_session, only: [:new, :create, :destroy]

  namespace :child_role do
    root "dashboards#show"
    resources :routines, only: [:index, :show] do
      resources :routine_executions, only: [:create]
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "tops#index"
end
