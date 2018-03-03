class TeacherImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id/10000.floor}/#{model.id/100.floor}/#{model.id}"
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path('biovision/base/placeholders/user.svg')
  end

  process :auto_orient

  def auto_orient
    manipulate! do |image|
      image.tap(&:auto_orient)
    end
  end

  version :medium do
    resize_to_fit(320, 320)
  end

  version :small, from_version: :medium do
    resize_to_fit(160, 160)
  end

  version :preview, from_version: :small do
    resize_to_fit(80, 80)
  end

  def extension_whitelist
    %w(jpg jpeg)
  end
end
