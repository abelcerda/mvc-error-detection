class PrimerosController < ApplicationController
  before_action :set_primero, only: [:show, :edit, :update, :destroy]
  require 'Phplexer'
  require 'scriptLexer'
  require 'ParserCanchero'
  require 'Hash'
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
    @uploaded_io = params[:primero][:archivo].read.downcase
    #----------- Script Lexer--------------------
    sections = ScriptLexer.new.parse(@uploaded_io)
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
    @rows = []
    @i = 0
    stack_php.each_with_index do |stk,index|
      @leaves,@rows = self.analizer_sections(stk,@leaves,offset_php[index],@rows) # Envio el offset para que sea suamdo a cada fila de las hojas ue corresponden con los tokens
    end
    puts @leaves
    #puts params[:primero][:archivo](149)
    file1 = params[:primero][:archivo].open()
    @rows = []
    file1.each_with_index do |line,index|
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
  end

  def analizer_sections(sections,leaves,offset,rows)
    if sections.is_a?(Array)
      @leaves,@rows = self.get_hashes(sections,@leaves,offset,rows)
    end
    return [@leaves,@rows]
  end

  def get_arrays(data,leaves,offset,rows)
    while data.is_a?(Hash)
      data.select { |key, value| @val = value; @key = key }
      if $elementsToAnalizer.include?(@key.to_s)
        #Sumar el offset
        @val[0] = (@val[0] + offset) - 1
        rows.push(@val[0]) 
        leaves.push(data)
      end
      data = @val
    end
    return [leaves,rows] # Sale del while cuando encuentra que un hijo es Array  

  end

  def get_hashes(data,leaves,offset,rows) #Recibe un array, data, y lo recorre xD
    i = 0
    while i < data.length
      data[i].select { |key, value| @val = value; @key = key }
      if @val.is_a?(Array)
        if $elementsToAnalizer.include?(@key.to_s) # se puede dar el caso de {:TOKEN => [x,y]}, por eso pregunto si la llave esta en el array de token que nos interesan.
          @val[0] = (@val[0] + offset) - 1
          rows.push(@val[0]) 
          leaves.push(data[i])
        else
          @val.each do |vl| #dado el caso {:KEY => [{},{},{}... {}]}, recorro el array y a cada hash lo pushe al array data.
            data.push(vl) #coloco al final al array para analizarlo despues  
          end
        end
      else
        if @val.is_a?(Hash) # Solamente si @val es un hash se llama a get_arrays, sino se lo pasa de largo y se suma el i
          leaves,rows = self.get_arrays(@val,leaves,offset,rows)# Recorro el hash atraves de sus hijos.
        end
      end
      i = i + 1
    end
    return [leaves,rows]
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
