class Teacher < ApplicationRecord
  mount_uploader :image, TeacherImageUploader
end
