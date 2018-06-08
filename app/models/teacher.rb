class Teacher < ApplicationRecord
  PER_PAGE          = 20
  NAME_LIMIT        = 50
  TITLE_LIMIT       = 200
  DESCRIPTION_LIMIT = 2000

  mount_uploader :image, TeacherImageUploader

  validates_presence_of :name, :surname
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :surname, maximum: NAME_LIMIT
  validates_length_of :title, maximum: TITLE_LIMIT
  validates_length_of :description, maximum: DESCRIPTION_LIMIT

  scope :ordered_by_name, -> { order('surname asc, name asc') }
  scope :list_for_visitors, -> { ordered_by_name }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    ordered_by_name.page(page).per(PER_PAGE)
  end

  # @param [Integer] page
  def self.page_for_visitors(page = 1)
    list_for_visitors.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(name surname title image description)
  end

  def full_name
    "#{name} #{surname}"
  end
end
