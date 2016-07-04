class PrimerosController < ApplicationController
  before_action :set_primero, only: [:show, :edit, :update, :destroy]
  require 'MVC-PHP'
  require 'PHPDependEngine'
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
		@files = []
		@rows = []
    @metrics = []
		#@analyzer = Primero.new(analyzer_params)
		#puts YAML::dump(params[:primero][:scripts])
		#puts YAML::dump(params[:images])
		#Realizar un try catch pra la lectura de los archivos temporales.
		if params[:primero][:scripts]
				 
					params[:primero][:scripts].each { |script|
						#@fichero = script.read  
							ex_file = script.content_type.split("/")
							file = script.read
							file_name = script.original_filename
              file_path = script.tempfile.path
              file_original_path = find_original_path(script.headers)
							script = script.open()
							script.each do | lines |
								@rows.push(lines)
							end
							#puts ex_file[1]
							#puts file
              if (ex_file[1] == "x-php")
                @analyzed_metrics = MetricAnalyzer.new.analyze_metrics(file_path, file_original_path)
              end
							if (ex_file[1] == "x-php") || (ex_file[1] == "html")
								begin
									sections = MvcPhp.new.getSections(file.downcase,@rows,file_original_path) #creo que es más preciso indicar la ruta completa por si hay casos donde haya archivos con el mismo nombre pero en distintas subcarpetas del proyecto
                  (!@analyzed_metrics.nil? && !@analyzed_metrics.empty?)? 
                    sections[:metrics] = @analyzed_metrics : 
                    FALSE # generar algún mensaje cuando no hay métricas para ese archivo
									@files.push(sections)
								rescue
									puts "se ha producido una excepcion. ------>"+file_name.to_s
								end
							else
								if ex_file[1] == "x-trash"
									flash[:notice] = 'El archivo #{file_name} que se ingresado se encuentra abierto y se esta editando.'
								end
							end
							@rows = []
					}
		end
		$lexical_analyzer = @files
		respond_to do |format|
			if @files.nil?
				format.html { redirect_to @primero, notice: 'Se ha analizado ocn exito todos sus archivos' }
				format.json { render :new, status: :created, location: @primero }
			else
				format.html { render :show }
				format.json { render json: @primero.errors, status: :unprocessable_entity }
			end
		end
	end

	def show_result
		
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
      #@primero = Primero.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def primero_params
      params.require(:primero).permit(:cadena, :resultado)
    end
    
    def get_metrics(file_path='')
      # TO DO: comprobar de alguna forma que la librería está disponible. UPDATE: necesario?
      # TO DO: retornar una cadena vacía en caso que la librería no se haya cargado bien 
      metrics = MetricAnalyzer.new.analyze_metrics(file_path)
      return metrics
    end
    
    def find_original_path(headers)
      filename =  headers.match('filename=[^;\n\r]+').to_s.split('=')
      return filename[1].to_s.gsub('"', '')
    end
end
