Rails.application.routes.draw do
  resources :course_categories, :course_tags, :courses, :teachers, only: [:update, :destroy]
  resources :course_lessons, :course_skills, :course_users, only: [:update, :destroy]

  scope '(:locale)', constraints: { locale: /[a-ln-z][a-z]|m[a-xz]/ } do
    resources :course_categories, :course_tags, except: [:update, :destroy]
    resources :courses, except: [:update, :destroy] do
      member do
        get 'lessons/(:number)' => :lesson, as: :lesson
      end
    end
    resources :teachers, only: [:new, :create, :edit]
    resources :course_lessons, :course_skills, only: [:create, :edit]

    namespace :admin do
      resources :course_categories, only: [:index, :show] do
        member do
          post 'priority', defaults: { format: :json }
          post 'toggle', defaults: { format: :json }
        end
      end
      resources :course_tags, only: [:index, :show] do
        member do
          post 'toggle', defaults: { format: :json }
        end
      end
      resources :courses, only: [:index, :show] do
        member do
          put 'lock', defaults: { format: :json }
          delete 'lock', action: :unlock, defaults: { format: :json }
          post 'priority', defaults: { format: :json }
          post 'toggle', defaults: { format: :json }
          put 'teachers/:teacher_id' => :add_teacher, as: :teacher, defaults: { format: :json }
          delete 'teachers/:teacher_id' => :remove_teacher, defaults: { format: :json }
          put 'course_tags/:course_tag_id' => :add_course_tag, as: :course_tag, defaults: { format: :json }
          delete 'course_tags/:course_tag_id' => :remove_course_tag, defaults: { format: :json }
          get 'lessons'
          get 'users'
          post 'users' => :create_user, defaults: { format: :json }
        end
      end
      resources :course_lessons, only: [:show]
      resources :course_skills, only: [:show] do
        member do
          post 'priority', defaults: { format: :json }
        end
      end

      resources :teachers, only: [:index, :show]
    end
  end
end
