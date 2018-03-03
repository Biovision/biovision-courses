class CourseSkillsController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # post /course_skills
  def create
    @entity = CourseSkill.new(creation_parameters)
    if @entity.save
      next_page = admin_course_path(@entity.course_id)
      respond_to do |format|
        format.html { redirect_to(next_page) }
        format.js { render(js: "document.location.href = '#{next_page}'") }
      end
    else
      render :new, status: :bad_request
    end
  end

  # get /course_skills/:id/edit
  def edit
  end

  # patch /course_skills/:id
  def update
    if @entity.update entity_parameters
      next_page = admin_course_path(@entity.course_id)
      respond_to do |format|
        format.html { redirect_to(next_page, notice: t('course_skills.update.success')) }
        format.js { render(js: "document.location.href = '#{next_page}'") }
      end
    else
      render :edit, status: :bad_request
    end
  end

  # delete /course_skills/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('course_skills.destroy.success')
    end
    redirect_to(admin_course_path(@entity.course_id))
  end

  protected

  def restrict_access
    require_privilege_group :course_managers
  end

  def set_entity
    @entity = CourseSkill.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find course_skill')
    end
  end

  def entity_parameters
    params.require(:course_skill).permit(CourseSkill.entity_parameters)
  end

  def creation_parameters
    params.require(:course_skill).permit(CourseSkill.creation_parameters)
  end
end
