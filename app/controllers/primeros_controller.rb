class PrimerosController < ApplicationController
  before_action :set_primero, only: [:show, :edit, :update, :destroy]
  require 'MVC-PHP'
  #variables para controlar elementos de un controlador y un modelo
  $elementsToAnalizer = ["PDO_METHODS","PDO_STATEMENT","GET","POST","DBA_STATEMENT"]
  $elementsOfModel = ["PDO_METHODS","PDO_STATEMENT","DBA_STATEMENT"]
  $elementsOfController = ["GET","POST"]
  # GET /primeros
  # GET /primeros.json
  def index
    @primeros = Primero.all
  end

  # GET /primeros/1
  # GET /primeros/1.json
  def show
  end

  # GET /primeros/new
  def new
    @primero = Primero.new
  end

  # GET /primeros/1/edit
  def edit
  end

  # POST /primeros
  # POST /primeros.json
  def create
    @primero = Primero.new
    @leaves = []
    @uploaded_io = params[:primero][:archivo].read.downcase
    if @uploaded_io.length != 0
      @leaves = MvcPhp.new.getSections(@uploaded_io)
      puts "*************"
      puts @leaves
      @rows = []
      file = params[:primero][:archivo].open()
      file.each_with_index do |line,index|
        @rows.push(line)
      end
      respond_to do |format|
        if @leaves.nil?
          format.html { redirect_to @primero, notice: 'Primero was successfully created.' }
          format.json { render :show, status: :created, location: @primero }
        else
          format.html { render :new }
          format.json { render json: @primero.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:notice] = 'El archivo que se ha ingresado esta vacio.'
      redirect_to :back
    end
  end

  # PATCH/PUT /primeros/1
  # PATCH/PUT /primeros/1.json
  def update
    respond_to do |format|
      if @primero.update(primero_params)
        format.html { redirect_to @primero, notice: 'Primero was successfully updated.' }
        format.json { render :show, status: :ok, location: @primero }
      else
        format.html { render :edit }
        format.json { render json: @primero.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /primeros/1
  # DELETE /primeros/1.json
  def destroy
    @primero.destroy
    respond_to do |format|
      format.html { redirect_to primeros_url, notice: 'Primero was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_primero
      @primero = Primero.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def primero_params
      params.require(:primero).permit(:cadena, :resultado)
    end
end
