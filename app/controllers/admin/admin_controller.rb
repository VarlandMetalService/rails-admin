module Admin
  class AdminController < ApplicationController
    include Pagy::Backend
    include ActionController::MimeResponds
    layout 'layouts/admin/application'

    before_action :set_object, only: [:edit, :destroy]
    after_action -> { flash.discard }, if: -> { request.xhr? }

    # Overides strong params
    def params
      request.parameters
    end

    def dashboard
    end

    def index
      # handle where
      if params[:where].blank?; 
        params[:where] = "1 = 1"
      else @where = params[:where]; end
      # handle includes
      if params[:includes].blank? || params[:includes].kind_of?(Array)
        @includes = params[:includes]
      else @includes = params[:includes].split(' '); end
      # handle sorting
      if params[:sort_by].present? && params[:class].present?
        @class = params[:class]; @attribute = params[:sort_by]; end
      # actual controller stuff
      if params[:model].present?
        @pagy, @objects = pagy(params[:model].constantize.
          includes( JSON.parse(@includes.to_json) ).
          where( Arel.sql(params[:where]) ).
          reorder( Arel.sql("#{params[:sort_by]} #{params[:sort_how]}") ), 
          link_extra: 'data-remote="true"') unless params[:model].blank?
        # still need class info if blank, create new!
        if @objects.blank?; @objects = [params[:model].constantize.new] end
        respond_to do |format|
          format.html
          format.js
        end
      end
    end

    def show
      @object = params[:model].constantize.find(params[:id]) unless params[:model].blank? || params[:id].blank?
      respond_to do |format|
        format.js
        format.html
      end
    end

    def new
      @object = params[:model].constantize.new()
      respond_to do |format|
        format.js
        format.html
      end
    end

    def edit
      respond_to do |format|
        format.js
        format.html
      end
    end

    def create
      @object = params[:object][:model].constantize.new(params[:object].except(:model, :id))
      respond_to do |format|
        if @object.save
          flash[:success] = "Succesfully created #{@object.class.name.demodulize} #{@object.id}."
          format.js { render 'show', model: params[:object][:model]}
        else
          flash[:danger] = "Failed to create #{@object.class.name.demodulize}."
          format.js { render 'new', model: params[:object][:model]}
        end
      end
    end

    def update
      respond_to do |format|
        @object = params[:object][:model].constantize.find(params[:object][:id])
        @updated = @object.update(params[:object].except(:model, :id))
        if @updated
          flash[:success] = "Succesfully updated #{@object.class.name.demodulize} #{@object.id}."
        else
          flash[:danger] = "Failed to update #{@object.class.name.demodulize}."
        end
        format.js
      end
    end

    def destroy
      if @object.destroy || @object.deleted_at.present?
        flash[:success] = "Successfully destroyed #{@object.class.name.demodulize} #{@object.id}."
      else
        flash[:danger] = "Failed to destroy #{@object.class.name.demodulize} #{@object.id}."
      end
      respond_to do |format|
        format.js
      end
    end

    private
      def set_object
        @object = params[:model].constantize.find(params[:id])
      end
  end
end
