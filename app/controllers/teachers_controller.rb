class TeachersController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # get /teachers/new
  def new
    @entity = Teacher.new
  end

  # post /teachers
  def create
    @entity = Teacher.new(entity_parameters)
    if @entity.save
      form_processed_ok(admin_teacher_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /teachers/:id/edit
  def edit
  end

  # patch /teachers/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_teacher_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /teachers/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('teachers.destroy.success')
    end
    redirect_to admin_teachers_path
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

  def entity_parameters
    params.require(:teacher).permit(Teacher.entity_parameters)
  end
end
