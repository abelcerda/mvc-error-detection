class PrimerosController < ApplicationController
  before_action :set_primero, only: [:show, :edit, :update, :destroy]
  require 'Phplexer'
  require 'scriptLexer'
  require 'ParserCanchero'
  require 'Hash'
  #variables para controlar elementos de un controlador y un modelo
  @elementsToAnalizer = ["PDO_METHODS","PDO_STATEMENT","GET","POST","DBA_STATEMENT"]
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
    uploaded_io = params[:primero][:archivo].read.downcase
    #----------- Script Lexer--------------------
    sections = ScriptLexer.new.parse(uploaded_io)
    optimus = Transformio.new.apply(sections)
    offset_php = [] # Array que va a contener le offset que se le sumara a los elementos del array @leaves
    #--------------------------------------------
    #---------PHP lexer---------
    bombembli = PhpLexer.new
    megatron = Transformer.new
    #---------------------------
    #---------HTML Lexer-------
    
    #--------------------------
    stack_php = []
    stack_html = []
    j = 0
    k = 0
    sections.each_with_index do |scts,index|
      scts.select { |key, value| @ky = key; @script = value }
      if @ky.to_s == "PHP_CODE" 
        code = @script.to_s.split("@")
        stack_php[j] = megatron.apply(bombembli.parse(code[0]))
        optimus[index].select { |key, value| @val = value } # Obtengo en la variable @val el array con la fila y la columna uqe van a ser los offset
        offset_php.push(@val[0])# Pusheo al array offset_php solamane el nro de fila que luego sera sumado a cada elemento del arreglo @leaves
        j = j + 1             
      elsif @ky.to_s == "HTML_SECTION" 
        code = @script.to_s.split("@")
        stack_html[j] = code[0]
        k = k + 1
      end           
    end
    @aux = Hash.new {|h,k| h[k]=[]}
    @leaves = []
    @i = 0
    stack_php.each_with_index do |stk,index|
      @leaves,@i = self.analizer_sections(stk,@leaves,@i,offset_php[index]) # Envio el offset para que sea suamdo a cada fila de las hojas ue corresponden con los tokens
    end
    puts "array cambiado"
    pp @leaves

    respond_to do |format|
      if @leaves.nil?
        format.html { redirect_to @primero, notice: 'Primero was successfully created.' }
        format.json { render :show, status: :created, location: @primero }
      else
        format.html { render :new }
        format.json { render json: @primero.errors, status: :unprocessable_entity }
      end
    end
  end

  def analizer_sections(sections,leaves,index,offset)
    sections.each do |trans|
        trans.select { |key, value| @auxi = value }
        @auxi,@leaves,@i = self.get_arrays(@auxi,@leaves,@i,offset)
        if @auxi.is_a?(Array)
          @auxi.each do |ax|
            @requecho,@leaves,@i = self.get_arrays(ax,@leaves,@i,offset)
          end 
        end
    end
    return [leaves,index]
  end

  def get_arrays(data,leaves,index,offset)
    while data.is_a?(Hash)
      data.select { |key, value| @auxi2 = value; @key_aux = key }
      #if @key_aux.to_s.include?(@elementsToAnalizer)
      if (@key_aux.to_s == "PDO_METHODS" || @key_aux.to_s == "PDO_STATEMENT" || @key_aux.to_s == "GET" || @key_aux.to_s == "POST" || @key_aux.to_s == "DBA_STATEMENT")
        #Sumar el offset
        @auxi2[0] = (@auxi2[0] + offset) - 1 
        leaves.push(data)
        index = index + 1
      end
      data = @auxi2
    end
    return [data,leaves,index]
  end

  
  def search_key(obj,key)
    if obj.respond_to?(:key?) && obj.key?(key)
      obj[key]
    elsif obj.respond_to?(:each)
      r = nil
      obj.find{ |*a| r=search_key(a.last,key) }
      r
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
