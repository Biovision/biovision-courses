class CourseCategoriesController < ApplicationController
  before_action :restrict_access, except: [:index, :show]
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :set_entity_for_visitor, only: [:show]

  layout 'admin', except: [:index, :show]

  # get /course_categories
  def index
  end

  # get /course_categories/new
  def new
    @entity = CourseCategory.new
  end

  # post /course_categories
  def create
    @entity = CourseCategory.new(creation_parameters)
    if @entity.save
      form_processed_ok(admin_course_category_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /course_categories/:id
  def show
    @collection = @entity.courses.page_for_visitors(current_page)
  end

  # get /course_categories/:id/edit
  def edit
  end

  # patch /course_categories/:id
  def update
    if @entity.update entity_parameters
      form_processed_ok(admin_course_category_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
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

  def set_entity_for_visitor
    @entity = CourseCategory.visible.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find visible course_category')
    end
  end

  def entity_parameters
    params.require(:course_category).permit(CourseCategory.entity_parameters)
  end

  def creation_parameters
    params.require(:course_category).permit(CourseCategory.creation_parameters)
  end
end
