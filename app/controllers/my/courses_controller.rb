class My::CoursesController < ApplicationController
  before_action :restrict_anonymous_access
  before_action :set_course, except: [:index]

  # get /my/courses
  def index
    @collection = CourseUser.page_for_owner(current_user, current_page)
  end

  # get /my/courses/:id
  def show
  end

  # get /my/courses/:id/lessons/:number
  def lesson
    @lesson = @entity.course_lessons.find_by(priority: params[:number])
    if @lesson.nil?
      handle_http_404('Cannot find lesson')
    end
  end

  private

  def set_course
    @entity = Course.find_by(id: params[:id])
    if @entity.nil? || !@entity.user?(current_user)
      handle_http_404("Cannot find course for user #{current_user&.id}")
    end
  end
end
