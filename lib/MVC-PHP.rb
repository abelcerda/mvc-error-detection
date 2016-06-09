require_relative 'AnalyzerSection'
require_relative 'PHPCodeAnalyzer'
require_relative 'ruby_constant/constant'

class MvcPhp
  @leaves = []

  def getSections(code,linesCode,file_name)
	sections_script = ScriptLexer.new.parse(code)
	optimus_script = Transformio.new.apply(sections_script)
   
	php_sections_analyzed = PhpLexer.new.parse(code)
	php_sections_transform = PhpTransformer.new.apply(php_sections_analyzed)

	k = 0
	j = 0
	stack_php = []
	stack_html = [] #Ya no se usa xD
	sections_php = [] # Array que va a contener le offset que se le sumara a los elementos del array @leaves
	hash = []
	php_sections_transform.each_with_index do |cod,index|
		stack_php = []
		cod.select { |key, value| @key = key; @script = value }
		if (@key.to_s == "PHP_SECTION") && (@script.is_a?(Array) || @script.is_a?(Hash))  
			@script.each do |line|
				stack_php = self.search_hashes(stack_php,line,linesCode,optimus_script[index])
			end
		end
		#hash = { :offset_section => optimus_script[index], :stack_php => stack_php,:file_name => file_name}
		if stack_php.nil? || stack_php.empty?
			stack_php = "empty"
		end
		hash.push(stack_php)
		#sections_php.push(hash)
		if @key.to_s == "HTML_SECTION"
			aux = @script.to_s.split("@")
			stack_html[k] = aux[0]
			k = k + 1
		end
	end
	sections_php = {:stack_php => hash,:file_name => file_name}
	#Llamada a la clase Php_Engine que
	#@leaves = PHPCodeAnalyzer.new.runPHP(stack_php,offset_php)
	return sections_php
  end

  def search_hashes(stack_php,array_list,script,offset_section)
	if array_list.is_a?(Array)
		array_list.each do |array_aux|
			self.search_hashes(stack_php,array_aux,script,offset_section)
		end
	else
		if array_list.is_a?(Hash)
			array_list.select { |key, value| @llave = key; @valor = value }
			#stack_php.push({:token => @llave, :line_code => script[@valor[0].to_i - 1], :column_number => (@valor[1].to_i) })
			stack_php.push({:token => @llave, :line_code => self.addHighlightsToToken(script[@valor[0].to_i - 1],@llave,@valor[1].to_i), :line_number => (@valor[0].to_i), :column_number => (@valor[1].to_i) })
		end
	end
	return stack_php
  end

  def addHighlightsToToken(line,key,col)
	vars = Variables.new()
	line = line.to_s
	key = key.to_s
	puts line
	puts "*****************************************"
	case key
		when "POST"
			#cad = line[(col - 1), line.length].split('$_POST',2)
			#cad = line[0 , (col - 1)] + cad[0] + "<span style='background-color: #A9F5A9'>$_POST</span>" + cad[1]
			cad = self.makeCommonActions('$_POST',line,col)
		when "GET"
			cad = self.makeCommonActions('$_GET',line,col)
		when "PDO_STATEMENT"  
			cad = self.makeCommonActions('new PDO',line,col)
			#cad = line
		when "PDO_METHODS"
			cad = line[(col - 1), line.length]
			band = true
			i = 0
			pdo_methods = vars.getPdoMethods()
			while ((i < pdo_methods.length) && band) do
				i+=1
				indice = cad.index(pdo_methods[i])
				if !indice.nil? && (indice == 0)
					cad = cad.split(pdo_methods[i],2)
					cad =  line[0 , (col - 1)] + cad[0] + "<span style='background-color: #A9F5A9'>"+pdo_methods[i]+"</span>" + cad[1]
					band = false
				end
			end
=begin
			vars.getPdoMethods().each do |pdo_methods|
				indice = cad.index(pdo_methods)
				if !indice.nil? && (indice == 0)
					puts indice
					cad = cad.split(pdo_methods,2)
					cad =  line[0 , (col - 1)] + cad[0] + "<span style='background-color: #A9F5A9'>"+pdo_methods+"</span>" + cad[1]
				end
			end
=end
		when "DBA_STATEMENT"
			cad = line[(col - 1), line.length]
			band = true
			j = 0
			dba_methods = vars.getDbaMethods()
			while ((j < dba_methods.length) && band) do
				j+=1
				indice = cad.index(dba_methods[j])
				if !indice.nil? && (indice == 0)
					cad = cad.split(dba_methods[j],2)
					cad =  line[0 , (col - 1)] + cad[0] + "<span style='background-color: #A9F5A9'>"+dba_methods[j]+"</span>" + cad[1]
					band = false
				end
			end
	end
	puts cad
	puts "=============================================="
	#"hello".tr_s('l', 'r')
	#line.insert(index, 'estosevaadecontrolar')
	#line
	cad
  end

  def makeCommonActions(token,line,col)
	cad = line[(col - 1), line.length].split(token,2)
	cad = line[0 , (col - 1)] + cad[0] + "<span style='background-color: #A9F5A9'>"+token+"</span>" + cad[1]
  	cad
  end
end
