Gem.loaded_specs['admin'].dependencies.each do |d|
  require d.name
 end
 require 'admin/engine'

module Admin
  class Engine < ::Rails::Engine
    isolate_namespace Admin
  end
end