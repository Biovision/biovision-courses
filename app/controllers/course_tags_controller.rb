class CourseTagsController < ApplicationController
  before_action :restrict_access, except: [:index, :show]
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :set_entity_for_visitor, only: [:show]

  layout 'admin', except: [:index, :show]

  # get /course_tags
  def index
  end

  # get /course_tags/new
  def new
    @entity = CourseTag.new
  end

  # post /course_tags
  def create
    @entity = CourseTag.new(entity_parameters)
    if @entity.save
      form_processed_ok(admin_course_tag_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /course_tags/:id
  def show
    @collection = @entity.courses.page_for_visitors(current_page)
  end

  # get /course_tags/:id/edit
  def edit
  end

  # patch /course_tags/:id
  def update
    if @entity.update entity_parameters
      form_processed_ok(admin_course_tag_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
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

  def set_entity_for_visitor
    @entity = CourseTag.visible.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find visible course_tag')
    end
  end

  def entity_parameters
    params.require(:course_tag).permit(CourseTag.entity_parameters)
  end
end
