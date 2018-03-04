class CourseLessonsController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # post /course_lessons
  def create
    @entity = CourseLesson.new(creation_parameters)
    if @entity.save
      next_page = lessons_admin_course_path(@entity.course_id)
      respond_to do |format|
        format.html { redirect_to(next_page) }
        format.js { render(js: "document.location.href = '#{next_page}'") }
      end
    else
      render :new, status: :bad_request
    end
  end

  # get /course_lessons/:id/edit
  def edit
  end

  # patch /course_lessons/:id
  def update
    if @entity.update entity_parameters
      next_page = lessons_admin_course_path(@entity.course_id)
      respond_to do |format|
        format.html { redirect_to(next_page, notice: t('course_lessons.update.success')) }
        format.js { render(js: "document.location.href = '#{next_page}'") }
      end
    else
      render :edit, status: :bad_request
    end
  end

  # delete /course_lessons/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('course_lessons.destroy.success')
    end
    redirect_to(lessons_admin_course_path(@entity.course_id))
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
