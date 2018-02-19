Rails.application.routes.draw do
  resources :courses
  resources :course_categories, :course_tags, except: [:index, :show]

  namespace :admin do
    resources :course_categories, only: [:index, :show] do
      member do
        post 'priority', defaults: { format: :json }
        post 'toggle', defaults: { format: :json }
      end
    end
    resources :course_tags, only: [:index, :show] do
      member do
        post 'priority', defaults: { format: :json }
        post 'toggle', defaults: { format: :json }
      end
    end
    resources :courses, only: [:index, :show] do
      member do
        put 'lock', defaults: { format: :json }
        delete 'lock', action: :unlock, defaults: { format: :json }
        post 'priority', defaults: { format: :json }
        post 'toggle', defaults: { format: :json }
      end
    end
  end
end
