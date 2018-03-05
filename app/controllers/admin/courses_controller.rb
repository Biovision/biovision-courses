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

  # put /admin/courses/:id/teachers/:teacher_id
  def add_teacher
    teacher = Teacher.find_by(id: params[:teacher_id])
    @entity.add_teacher(teacher) unless teacher.nil?

    head :no_content
  end

  # delete /admin/courses/:id/teachers/:teacher_id
  def remove_teacher
    teacher = Teacher.find_by(id: params[:teacher_id])
    @entity.remove_teacher(teacher) unless teacher.nil?

    head :no_content
  end

  # put /admin/courses/:id/course_tags/:course_tag_id
  def add_course_tag
    course_tag = CourseTag.find_by(id: params[:course_tag_id])
    @entity.add_course_tag(course_tag) unless course_tag.nil?

    head :no_content
  end

  # delete /admin/courses/:id/course_tags/:course_tag_id
  def remove_course_tag
    course_tag = CourseTag.find_by(id: params[:course_tag_id])
    @entity.remove_course_tag(course_tag) unless course_tag.nil?

    head :no_content
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
