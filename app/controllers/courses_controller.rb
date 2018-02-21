class CoursesController < ApplicationController
  before_action :restrict_access, only: [:new, :create]
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  layout 'admin', only: [:new, :edit]

  # get /courses
  def index
    @collection = Course.page_for_visitors(current_page)
  end

  # get /courses/new
  def new
    @entity = Course.new
  end

  # post /courses
  def create
    @entity = Course.new(creation_parameters)
    if @entity.save
      next_page = admin_course_path(@entity.id)
      respond_to do |format|
        format.html { redirect_to next_page }
        format.json { render json: { links: { self: next_page } } }
        format.js { render js: "document.location.href = '#{next_page}'" }
      end
    else
      render :new, status: :bad_request
    end
  end

  # get /courses/:id
  def show
    @entity = Course.find_by(id: params[:id], visible: true, deleted: false)
    if @entity.nil?
      handle_http_404("Cannot find non-deleted course #{params[:id]}")
    end
  end

  # get /courses/:id/edit
  def edit
  end

  # patch /courses/:id
  def update
    if @entity.update(entity_parameters)
      next_page = admin_course_path(@entity.id)
      respond_to do |format|
        format.html { redirect_to next_page }
        format.json { render json: { links: { self: next_page } } }
        format.js { render js: "document.location.href = '#{next_page}'" }
      end
    else
      render :edit, status: :bad_request
    end
  end

  # delete /courses/:id
  def destroy
    if @entity.destroy #@entity.update(deleted: true)
      flash[:notice] = t('courses.destroy.success')
    end
    redirect_to admin_courses_path
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

  def restrict_editing
    if @entity.locked? || !@entity.editable_by?(current_user)
      handle_http_403('Course is locked or not editable by current user')
    end
  end

  def entity_parameters
    params.require(:course).permit(Course.entity_parameters)
  end

  def creation_parameters
    parameters = params.require(:course).permit(Course.entity_parameters)
    parameters.merge(owner_for_entity(true))
  end
end
