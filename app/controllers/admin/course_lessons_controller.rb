class Admin::CourseLessonsController < AdminController
  before_action :set_entity

  # get /admin/course_lessons/:id
  def show
    @collection = @entity.courses.page_for_administration(current_page)
  end

  private

  def set_entity
    @entity = CourseLesson.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find course lesson')
    end
  end

  def restrict_access
    require_privilege_group :course_managers
  end
end
