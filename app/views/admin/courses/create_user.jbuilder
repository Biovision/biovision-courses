if @course_user.valid?
  json.data do
    json.id @course_user.id
    json.type @course_user.class.table_name
    json.attributes do
      json.(@course_user, :price, :finished)
    end
    json.meta do
      json.html render(partial: 'admin/course_users/entity/in_list', formats: [:html], locals: { entity: @course_user })
    end
  end
else
  json.errors do
    json.array! @course_user.errors.full_messages
  end
end