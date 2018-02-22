module BiovisionCoursesHelper
  # @param [CourseTag] entity
  # @param [String] text
  def admin_course_tag_link(entity, text = entity.name)
    link_to(text, admin_course_tag_path(entity.id))
  end

  # @param [CourseCategory] entity
  # @param [String] text
  def admin_course_category_link(entity, text = entity.name)
    link_to(text, admin_course_category_path(entity.id))
  end

  # @param [Course] entity
  # @param [String] text
  def admin_course_link(entity, text = entity.title)
    link_to(text, admin_course_path(entity.id))
  end

  def course_categories_for_select
    options = []
    CourseCategory.for_tree.each do |category|
      options << [category.name, category.id]
      if category.child_categories.any?
        CourseCategory.for_tree(category.id).each do |subcategory|
          options << ["-#{subcategory.name}", subcategory.id]
          if subcategory.child_categories.any?
            CourseCategory.for_tree(subcategory.id).each do |deep_category|
              options << ["--#{deep_category.name}", deep_category.id]
            end
          end
        end
      end
    end
    options
  end

  # @param [Course] entity
  # @param [String] text
  # @param [Hash] options
  def course_link(entity, text = entity.title, options = {})
    link_to(text, course_path(entity.id), options)
  end

  # @param [CourseCategory] entity
  # @param [String] text
  # @param [Hash] options
  def course_category_link(entity, text = entity.name, options = {})
    link_to(text, course_category_path(entity.id), options)
  end

  # @param [CourseTag] entity
  # @param [String] text
  # @param [Hash] options
  def course_tag_link(entity, text = entity.name, options = {})
    link_to(text, course_tag_path(entity.id), options)
  end

  # Course image preview for displaying in "administrative" lists
  #
  # @param [Course] entity
  def course_image_preview(entity)
    return '' if entity.image.blank?

    versions = "#{entity.image.preview_2x.url} 2x"
    image_tag(entity.image.preview.url, alt: entity.title, srcset: versions)
  end

  # Small course image for displaying in lists of courses and feeds
  #
  # @param [Course] entity
  # @param [Hash] add_options
  def course_image_small(entity, add_options = {})
    return '' if entity.image.blank?

    alt_text = entity.image_alt_text.to_s
    versions = "#{entity.image.medium.url} 2x"
    options  = { alt: alt_text, srcset: versions }.merge(add_options)
    image_tag(entity.image.small.url, options)
  end

  # Medium course image for displaying on course page
  #
  # @param [Course] entity
  # @param [Hash] add_options
  def course_image_medium(entity, add_options = {})
    return '' if entity.image.blank?

    alt_text = entity.image_alt_text.to_s
    versions = "#{entity.image.big.url} 2x"
    options  = { alt: alt_text, srcset: versions }.merge(add_options)
    image_tag(entity.image.medium.url, options)
  end
end