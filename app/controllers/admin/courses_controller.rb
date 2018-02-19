class Admin::CoursesController < AdminController
  include LockableEntity
  include ToggleableEntity
  include EntityPriority

  before_action :set_entity, except: [:index]

  # get /admin/courses
  def index
  end

  # get /admin/courses/:id
  def show
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
