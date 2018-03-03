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
      next_page = admin_teacher_path(@entity.id)
      respond_to do |format|
        format.html { redirect_to next_page }
        format.js { render js: "document.location.href = '#{next_page}'" }
      end
    else
      render :new, status: :bad_request
    end
  end

  # get /teachers/:id/edit
  def edit
  end

  # patch /teachers/:id
  def update
    if @entity.update(entity_parameters)
      next_page = admin_teacher_path(@entity.id)
      respond_to do |format|
        format.html { redirect_to next_page }
        format.js { render js: "document.location.href = '#{next_page}'" }
      end
    else
      render :edit, status: :bad_request
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
