class NuevoController < ApplicationController
require 'Mini'
  def index
      #@hola = Mini.new
      #pp @parslet = Mini.new.parse("234234")
      #@varparslet = @parslet.parse("98792873423")
      puts YAML::dump(@parslet)
  end
end
