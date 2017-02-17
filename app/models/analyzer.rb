#class Analyzer < ActiveRecord::Base
class Analyzer 
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  def initialize
    @errors = ActiveModel::Errors.new(self)
  end
  
  attr_accessor :name
  attr_reader   :errors

  def validate!
    errors.add(:name, :blank, message: "cannot be nil") if name.nil?
  end

  # The following methods are needed to be minimally implemented

  def read_attribute_for_validation(attr)
    send(attr)
  end

  def self.lookup_ancestors
    [self]
  end
 
  def persisted?
    false
  end
end
