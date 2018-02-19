class CourseTag < ApplicationRecord
  include RequiredUniqueName
  include RequiredUniqueSlug
  include Toggleable

  PER_PAGE          = 20
  NAME_LIMIT        = 50
  SLUG_LIMIT        = 50
  SLUG_PATTERN      = /\A[a-z][-0-9a-z]*[0-9a-z]\z/i
  SLUG_PATTERN_HTML = '^[a-zA-Z][-0-9a-zA-Z]*[0-9a-zA-Z]$'

  toggleable :visible

  mount_uploader :image, CourseImageUploader

  before_validation { self.slug = Canonizer.transliterate(name.to_s) if slug.blank? }
  before_validation { self.slug = slug.to_s.downcase }
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_format_of :slug, with: SLUG_PATTERN

  scope :visible, -> { where(visible: true) }
  scope :list_for_visitors, -> { visible.ordered_by_name }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    ordered_by_name.page(page).per(PER_PAGE)
  end

  # @param [Integer] page
  def self.page_for_visitors(page = 1)
    list_for_visitors.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(visible image name slug)
  end
end
