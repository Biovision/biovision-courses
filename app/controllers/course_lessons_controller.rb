class CourseLessonsController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # post /course_lessons
  def create
    @entity = CourseLesson.new(creation_parameters)
    if @entity.save
      form_processed_ok(lessons_admin_course_path(id: @entity.course_id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /course_lessons/:id/edit
  def edit
  end

  # patch /course_lessons/:id
  def update
    if @entity.update entity_parameters
      form_processed_ok(lessons_admin_course_path(id: @entity.course_id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /course_lessons/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('course_lessons.destroy.success')
    end
    redirect_to(lessons_admin_course_path(id: @entity.course_id))
  end

  protected

  def restrict_access
    require_privilege_group :course_managers
  end

  def set_entity
    @entity = CourseLesson.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find course_lesson')
    end
  end

  def entity_parameters
    params.require(:course_lesson).permit(CourseLesson.entity_parameters)
  end

  def creation_parameters
    params.require(:course_lesson).permit(CourseLesson.creation_parameters)
  end
end
