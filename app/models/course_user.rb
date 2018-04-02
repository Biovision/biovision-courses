class CourseUser < ApplicationRecord
  include HasOwner

  belongs_to :course, counter_cache: :users_count, touch: false
  belongs_to :user

  validates_uniqueness_of :user_id, scope: [:course_id]

  scope :list_for_administration, -> { order('id desc') }
  scope :recent, -> { order('id desc') }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  # @param [User] user
  # @param [Integer] page
  def self.page_for_owner(user, page = 1)
    owned_by(user).recent.page(page)
  end

  def self.creation_parameters
    %i(course_id user_id price finished)
  end
end
