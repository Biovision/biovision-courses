json.data @collection do |entity|
  json.id entity.id
  json.type entity.class.table_name
  json.attributes do
    json.(entity, :title, :subtitle, :lead, :duration)
  end
  json.meta do
    unless entity.image.blank?
      json.image do
        json.small entity.image.small.url
        json.small_2x entity.image.medium.url
      end
    end
    json.html render(partial: 'courses/preview', formats: [:html], locals: { entity: entity } )
  end
end
json.partial! 'shared/pagination', locals: { collection: @collection }
