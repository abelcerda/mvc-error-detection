class AnalyzersController < ApplicationController
  before_action :set_analyzer, only: [:show, :edit, :update, :destroy]
  require 'MVCAnalyzer/MVCEngine'
  require 'MetricAnalyzer/PHPDependEngine'
  #variables para controlar elementos de un controlador y un modelo
  $elementsToAnalizer = ["PDO_METHODS","PDO_STATEMENT","GET","POST","DBA_STATEMENT"]
  $elementsOfModel = ["PDO_METHODS","PDO_STATEMENT","DBA_STATEMENT"]
  $elementsOfController = ["GET","POST"]
  # GET /analyzers
  # GET /analyzers.json
  def index
#    @analyzers = Analyzer.all
  end

	# GET /analyzers/1
	# GET /analyzers/1.json
	def show
		if params[:id] == 'pdf'
      render :pdf => "file_name",
              :orientation  => 'Portrait',
              :margin => { :top => 8.5,
                           :bottom => 8.5,
                           :left => 6,
                           :right => 6
                          },
              :template => 'analyzers/report.erb',
              :disposition => 'attachment'  
      return
    end
	end 

	# GET /analyzers/new
	def new
		@analyzer = Analyzer.new
	end

	# GET /analyzers/1/edit
	def edit
	end

	# POST /analyzers
	# POST /analyzers.json
	def create
		@analyzer = Analyzer.new
		@files = []
		@rows = []
    @metrics = []
    @qty_components_type = {:model => 0, :controller => 0, :view => 0, :multi_type => 0}
		#@analyzer = Analyzer.new(analyzer_params)
		#puts YAML::dump(params[:analyzer][:scripts])
		#puts YAML::dump(params[:images])
		#Realizar un try catch pra la lectura de los archivos temporales.
		if params[:analyzer][:scripts]
				 
					params[:analyzer][:scripts].each { |script|
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
									sections = MVCEngine.new.getSections(file.downcase,@rows,file_original_path) #creo que es más preciso indicar la ruta completa por si hay casos donde haya archivos con el mismo nombre pero en distintas subcarpetas del proyecto
                  
									self.getStadistics(sections)

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
		$stadistics = @qty_components_type
		$lexical_analyzer = @files
		respond_to do |format|
			if @files.nil?
				format.html { redirect_to @analyzer, notice: 'Se ha analizado ocn exito todos sus archivos' }
				format.json { render :new, status: :created, location: @analyzer }
			else
				format.html { render :show }
				format.json { render json: @analyzer.errors, status: :unprocessable_entity }
			end
		end
	end

	def getStadistics(sections)
		if sections[:operation][:model] && !sections[:operation][:controller] && !sections[:operation][:view]
			@qty_components_type[:model] += 1
		end
		
		if sections[:operation][:view] && !sections[:operation][:controller] && !sections[:operation][:model]
			@qty_components_type[:view] += 1
		end
		
		if sections[:operation][:controller] && !sections[:operation][:model] && !sections[:operation][:view]
			@qty_components_type[:controller] += 1
		end

		if (sections[:operation][:model] && sections[:operation][:view]) || (sections[:operation][:model] && sections[:operation][:controller]) || (sections[:operation][:controller] && sections[:operation][:view])
			@qty_components_type[:multi_type] += 1
    end
	end

	# PATCH/PUT /analyzers/1
	# PATCH/PUT /analyzers/1.json
	def update
		respond_to do |format|
			if @analyzer.update(analyzer_params)
				format.html { redirect_to @analyzer, notice: 'Analyzer was successfully updated.' }
				format.json { render :show, status: :ok, location: @analyzer }
			else
				format.html { render :edit }
				format.json { render json: @analyzer.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /analyzers/1
	# DELETE /analyzers/1.json
	def destroy
		@analyzer.destroy
		respond_to do |format|
			format.html { redirect_to analyzers_url, notice: 'Analyzer was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_analyzer
      #@analyzer = Analyzer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def analyzer_params
      params.require(:analyzer).permit(:cadena, :resultado)
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
