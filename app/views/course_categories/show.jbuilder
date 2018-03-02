json.data do
  json.id @entity.id
  json.type @entity.class.table_name
  json.attributes do
    json.(@entity, :parent_id, :title)
  end
end
json.included @collection do |course|
  json.id course.id
  json.type course.class.table_name
  json.meta do
    json.html render(partial: 'courses/preview', formats: [:html], locals: { entity: course })
  end
end
json.partial! 'shared/pagination', locals: { collection: @collection }
