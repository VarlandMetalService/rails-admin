module Admin
  class ApplicationController < ActionController::Base
    include ::ActionView::Layouts
    layout 'application'
  end
end
