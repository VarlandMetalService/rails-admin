module Admin::AdminHelper
  include FontAwesome::Rails::IconHelper;
  include Pagy::Frontend;

  def app_models
    x = Rails.configuration.eager_load_namespaces
    x.delete(ActiveStorage::Engine)
    x.each(&:eager_load!)
    mdls = Hash[ActiveRecord::Base.descendants.reject{ |v| v.name == "Admin::ApplicationRecord" || v.name == 'ActiveStorage::Blob::Analyzable' || v.name == 'Thickness::ThicknessRecord'|| v.name == 'ApplicationRecord' || v.name == "ActiveRecord::SchemaMigration" || v.name.safe_constantize.blank? }.map(&:name).collect { |v| [v, v.constantize.reflect_on_all_associations.map(&:name) ] }]
    models = {}
    mdls.each do |model|
      if models[model[0].constantize.to_s].present?
        puts 'WKF:JLDDJFLKDSJFLDSKFJDSJFJDSJFLDJSFJldsjfdjsflksd'
      end
      unless model[0].blank? 
        models[model[0].constantize.parent.to_s] ||= []
        models[model[0].constantize.parent.to_s] << model
      end
    end
    models["Object"] = models.delete("Object")
    models.delete("ActiveStorage")
    models.each do |section|
      if section[0].include?('::') && models[section[0].split('::').first].present?
        old = models[section[0].split('::').first]
        models[section[0].split('::').first].each_with_index do |value, index|
          if value[0].to_s == section[0].to_s
            temp =  old.delete_at(index)
            section[1].insert(0, temp)
          end
        end
      end
    end
    return models
  end

  def page_title
    if action_name == 'index'
      "#{controller_name.classify} #{action_name}".titleize
    else
      "#{action_name} #{controller_name.classify}".titleize
    end
  end

  # Links
  def admin_association_link(association, object)
    case association.macro.to_s
    when 'belongs_to' 
      admin_link(object.send(association.name)) 
    when 'has_one' 
      admin_link(object.send(association.name))
    when 'has_many' 
      admin_collection_link(object.send(association.name), association, object)
    when 'has_one :through'
      admin_link(object.send(association.name)) 
    when 'has_many :through' 
      admin_collection_link(object.send(association.name), association, object)
    when 'has_and_belongs_to_many' 
      admin_collection_link(object.send(association.name), association, object)
    end 
  end

  def admin_collection_link(collection, association, object)
    output = "<a class='collapse-btn collapsed' data-toggle='collapse' href='##{association.name}#{object.id}'>[ + ]</a>
    <span class='badge badge-secondary'>
      #{collection.length}
    </span>
    <div class='collapse' id='#{association.name}#{object.id}'>"
    collection.each do |col|
      output << admin_link(col) << '<br>'
    end
    output << "</div>"
    return output.html_safe
  end

  def admin_link(object)
      link_to object.display, show_path(model: "#{object.class.name.constantize}", id: object.id ), class:'' unless object.blank?
  end

  # Form fields
  def admin_association_form_field(association, form)
    case association.macro.to_s
    when 'belongs_to' 
      form.association association.name, label_method: :display
    when 'has_one' 
      # form.association association.name, label_method: :display
    when 'has_many'
      form.association association.name, label_method: :display
    when 'has_one :through'
      # form.association association.name, label_method: :display 
    when 'has_many :through'
      # form.association association.name, label_method: :display
    when 'has_and_belongs_to_many'
      form.association association.name, style: 'height: 600px;', label_method: :display
    end 
  end

  def get_attributes(model)
    ignored_attributes = ['deleted_at', 'id', 'remember_digest'] + Rails.application.config.filter_parameters.map { |a| a.to_s }

    model.column_names.reject { |col| ignored_attributes.include? col }.reject { |col| get_associations(model).map { |a| a.foreign_key.to_s }.include? col}
  end

  def get_associations(model)
    model.reflect_on_all_associations
  end

  def admin(text, model, options={})
    link_to raw("#{text}&nbsp;<span class='badge badge-secondary pull-right'>#{model.constantize.count}</span>"), index_path(model: model, includes: options[:includes]), style: 'text-align: left !important;',class: 'admin_btn ' + options[:class], data: {model: "#{model.constantize}", includes: options[:includes], disable_with: fa_icon('spinner spin', text: '<small>*thinking...*</small>'.html_safe)}
  end
end