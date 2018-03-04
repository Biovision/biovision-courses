class Admin::CoursesController < AdminController
  include LockableEntity
  include ToggleableEntity
  include EntityPriority

  before_action :set_entity, except: [:index]

  # get /admin/courses
  def index
    @collection = Course.page_for_administration(current_page)
  end

  # get /admin/courses/:id
  def show
  end

  # get /admin/courses/:id/lessons
  def lessons
    @collection = @entity.course_lessons.ordered_by_priority
  end

  private

  def set_entity
    @entity = Course.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find course')
    end
  end

  def restrict_access
    require_privilege_group :course_managers
  end
end
