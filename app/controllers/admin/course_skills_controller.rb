class Admin::CourseSkillsController < AdminController
  include EntityPriority

  before_action :set_entity

  # get /admin/course_skills/:id
  def show
  end

  private

  def set_entity
    @entity = CourseSkill.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find course_skill')
    end
  end

  def restrict_access
    require_privilege_group :course_managers
  end
end
