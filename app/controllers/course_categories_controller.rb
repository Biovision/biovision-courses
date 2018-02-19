class CourseCategoriesController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # get /course_categories/new
  def new
    @entity = CourseCategory.new
  end

  # post /course_categories
  def create
    @entity = CourseCategory.new(creation_parameters)
    if @entity.save
      next_page = admin_course_category_path(@entity.id)
      respond_to do |format|
        format.html { redirect_to(next_page) }
        format.json { render json: { links: { self: next_page } } }
        format.js { render(js: "document.location.href = '#{next_page}'") }
      end
    else
      render :new, status: :bad_request
    end
  end

  # get /course_categories/:id/edit
  def edit
  end

  # patch /course_categories/:id
  def update
    if @entity.update entity_parameters
      next_page = admin_course_category_path(@entity.id)
      respond_to do |format|
        format.html { redirect_to(next_page, notice: t('course_categories.update.success')) }
        format.json { render json: { links: { self: next_page } } }
        format.js { render(js: "document.location.href = '#{next_page}'") }
      end
    else
      render :edit, status: :bad_request
    end
  end

  # delete /course_categories/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('course_categories.destroy.success')
    end
    redirect_to(admin_course_categories_path)
  end

  protected

  def restrict_access
    require_privilege :chief_course_manager
  end

  def set_entity
    @entity = CourseCategory.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find course_category')
    end
  end

  def entity_parameters
    params.require(:course_category).permit(CourseCategory.entity_parameters)
  end

  def creation_parameters
    params.require(:course_category).permit(CourseCategory.creation_parameters)
  end
end
