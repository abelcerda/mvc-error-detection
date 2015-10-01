# encoding: UTF-8
class HtmlCodesController < ApplicationController
  require 'MVC-HTML'
  
  file_extensions = {
    'php' => 'PHP5.4',
    'htm' => 'HTML5',
    'html' => 'HTML5',
    'js' => 'Javascript5'
  }
  
  languages = {
    'PHP5.4' => 'MVC-PHP',
    'HTML5' => 'MVC-HTML',
    'Javascript5.1' => 'MVC-JS'
  }
  
  def new
    @htmlCode = HtmlCode.new
  end
  
  def create
    @htmlCode = HtmlCode.new
    @leaves = []
    @uploaded_io = params[:html_code][:archivo].read.downcase
    if @uploaded_io.length != 0
      @leaves = MVCHTML.new.parse_HTML(@uploaded_io, true)
      puts "*************"
      pp @leaves
      @rows = []
      file = params[:html_code][:archivo].open()
      file.each_with_index do |line,index|
        @rows.push(line)
      end
      respond_to do |format|
        if @leaves.nil?
          format.html { redirect_to @htmlCode, notice: 'Primero was successfully created.' }
          format.json { render :show, status: :created, location: @htmlCode }
        else
          format.html { render :new }
          format.json { render json: @htmlCode.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:notice] = 'El archivo que se ha ingresado esta vacio.'
      redirect_to :back
    end
  end
  
  def show
    
  end
  
  def index
    
  end
end
