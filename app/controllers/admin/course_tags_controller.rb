class Admin::CourseTagsController < AdminController
  include ToggleableEntity

  before_action :set_entity, except: [:index]

  # get /admin/course_tags
  def index
    @collection = CourseTag.page_for_administration(current_page)
  end

  # get /admin/course_tags/:id
  def show
    @collection = @entity.courses.page_for_administration(current_page)
  end

  private

  def set_entity
    @entity = CourseTag.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find course tag')
    end
  end

  def restrict_access
    require_privilege :chief_course_manager
  end
end
