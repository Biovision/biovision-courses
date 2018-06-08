class Admin::TeachersController < AdminController
  include ToggleableEntity

  before_action :set_entity, except: [:index]

  # get /admin/teachers
  def index
    @collection = Teacher.page_for_administration(current_page)
  end

  # get /admin/teachers/:id
  def show
  end

  private

  def set_entity
    @entity = Teacher.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find teacher')
    end
  end

  def restrict_access
    require_privilege_group :course_managers
  end
end
