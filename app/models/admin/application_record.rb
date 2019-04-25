module Admin
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def self.attributes
      self.column_names.reject { |col| Ignored_attributes.include? col }.reject { |col| self.associations.map { |a| a.foreign_key.to_s }.include? col}
    end
    
    def self.associations
      self.reflect_on_all_associations
    end

    def display
      "#{self.class.name.demodulize} #{self.id}"
    end
  end
end