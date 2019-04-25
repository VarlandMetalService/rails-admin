Gem.loaded_specs['admin'].dependencies.each do |d|
  require d.name
 end
 require 'admin/engine'

module Admin
  class Engine < ::Rails::Engine
    isolate_namespace Admin

    initializer "admin", before: :load_config_initializers do |app|
      Rails.application.routes.append do
        mount Admin::Engine, at: "/admin"
      end
    end
  end
end
