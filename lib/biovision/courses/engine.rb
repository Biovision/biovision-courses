require 'biovision/base'
require 'carrierwave'
require 'carrierwave-bombshelter'
require 'mini_magick'

module Biovision
  module Courses
    class Engine < ::Rails::Engine
      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_bot, :dir => 'spec/factories'
      end

      config.assets.precompile << %w(admin.scss)
      config.assets.precompile << %w(biovision/base/**/*)
    end
  end
end
