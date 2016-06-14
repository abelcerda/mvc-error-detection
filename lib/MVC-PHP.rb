require_relative 'AnalyzerSection'
require_relative 'PHPCodeAnalyzer'
require_relative 'ruby_constant/constant'

class MvcPhp
  @leaves = []
  original_string = ""
  downcase_string = ""

  def getSections(code,linesCode,file_name)
	sections_script = ScriptLexer.new.parse(code)
	optimus_script = Transformio.new.apply(sections_script)
   
	php_sections_analyzed = PhpLexer.new.parse(code)
	php_sections_transform = PhpTransformer.new.apply(php_sections_analyzed)

	k = 0
	j = 0
	stack_php = []
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
			
			#stack_php.push({:token => @llave, :line_code => script[@valor[0].to_i - 1], :column_number => (@valor[1].to_i) ,:line_number => (@valor[0].to_i)})
			stack_php.push({:token => @llave, :line_code => self.addHighlightsToToken(script[@valor[0].to_i - 1],@llave,@valor[1].to_i), :line_number => (@valor[0].to_i), :column_number => (@valor[1].to_i) })
		end
	end
	return stack_php
  end

  def addHighlightsToToken(line,key,col)
	vars = Variables.new()
	cad_aux = line.to_s
	line = line.to_s
	line = line.downcase
	key = key.to_s
	case key
		when "POST"
			cad = self.makeCommonActions('$_post',cad_aux,col)
		when "GET"
			cad = self.makeCommonActions('$_get',cad_aux,col)
		when "PDO_STATEMENT"  
			cad = self.makeCommonActions('new pdo',cad_aux,col)
			#cad = line
		when "PDO_METHODS"
			first_part = cad_aux[0,(col - 1)]
			cad = line[(col - 1), line.length] # toma a partir del token en adelante.
			band = true
			i = 0
			pdo_methods = vars.getPdoMethods()
			while ((i < pdo_methods.length) && band) do
				indice = cad.index(pdo_methods[i])
				if !indice.nil? && (indice == 0)
					second_part = cad_aux[(pdo_methods[i].length),cad_aux.length]
					cad = first_part + "<span style='background-color: #A9F5A9'>"+cad_aux[(col-1),(pdo_methods[i].length)]+"</span>"+second_part
					band = false
				end
				i+=1
			end
		when "DBA_STATEMENT"
			first_part = cad_aux[0,(col - 1)]
			cad = line[(col - 1), line.length]
			band = true
			j = 0
			dba_methods = vars.getDbaMethods()
			while ((j < dba_methods.length) && band) do
				indice = cad.index(dba_methods[j])
				if !indice.nil? && (indice == 0)
					second_part = cad_aux[(dba_methods[j].length),cad_aux.length]
					cad = first_part + "<span style='background-color: #A9F5A9'>"+cad_aux[(col-1),(dba_methods[j].length)]+"</span>"+second_part
					band = false
				end
				j+=1
			end
	end
	#"hello".tr_s('l', 'r')
	#line.insert(index, 'estosevaadecontrolar')
	#line
	cad
  end

  def makeCommonActions(token,line,col)
	cad = line[0 , (col - 1)] + "<span style='background-color: #A9F5A9'>"+line[(col-1),token.length]+"</span>" + line[((col-1) + token.length),line.length]
  	cad
  end
end
