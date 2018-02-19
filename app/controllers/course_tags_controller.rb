class CourseTagsController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # get /course_tags/new
  def new
    @entity = CourseTag.new
  end

  # post /course_tags
  def create
    @entity = CourseTag.new(entity_parameters)
    if @entity.save
      next_page = admin_course_tag_path(@entity.id)
      respond_to do |format|
        format.html { redirect_to(next_page) }
        format.json { render json: { links: { self: next_page } } }
        format.js { render(js: "document.location.href = '#{next_page}'") }
      end
    else
      render :new, status: :bad_request
    end
  end

  # get /course_tags/:id/edit
  def edit
  end

  # patch /course_tags/:id
  def update
    if @entity.update entity_parameters
      next_page = admin_course_tag_path(@entity.id)
      respond_to do |format|
        format.html { redirect_to(next_page, notice: t('course_tags.update.success')) }
        format.json { render json: { links: { self: next_page } } }
        format.js { render(js: "document.location.href = '#{next_page}'") }
      end
    else
      render :edit, status: :bad_request
    end
  end

  # delete /course_tags/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('course_tags.destroy.success')
    end
    redirect_to(admin_course_tags_path)
  end

  protected

  def restrict_access
    require_privilege :chief_course_manager
  end

  def set_entity
    @entity = CourseTag.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find course_tag')
    end
  end

  def entity_parameters
    params.require(:course_tag).permit(CourseTag.entity_parameters)
  end
end
