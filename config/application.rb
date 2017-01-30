require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EcomApi
  class Application < Rails::Application

    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.view_specs false
      g.helper_specs false
      g.stylesheets = false
      g.javascripts = false
      g.helper = false
    end

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir[File.join(Rails.root, 'lib', 'core_ext/**/', '*.rb')].each {|l| require l }
    config.autoload_paths += Dir[File.join(Rails.root, 'decorators', '*rb')]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
    config.time_zone = 'Kolkata'
    config.active_record.raise_in_transactional_callbacks = true
    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => :any
      end
    end
  end
end
