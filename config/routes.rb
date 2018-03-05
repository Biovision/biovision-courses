Rails.application.routes.draw do
  resources :courses, :course_categories, :course_tags
  resources :teachers, except: [:index, :show]
  resources :course_lessons, :course_skills, except: [:new, :index, :show]

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
