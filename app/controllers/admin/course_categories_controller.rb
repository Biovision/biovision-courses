class Admin::CourseCategoriesController < AdminController
  include ToggleableEntity
  include EntityPriority

  before_action :set_entity, except: [:index]

  # get /admin/course_categories
  def index
  end

  # get /admin/course_categories/:id
  def show
    @collection = @entity.courses.page_for_administration(current_page)
  end

  private

  def set_entity
    @entity = CourseCategory.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find course category')
    end
  end

  def restrict_access
    require_privilege :chief_course_manager
  end
end
