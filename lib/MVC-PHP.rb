require_relative 'AnalyzerSection'
require_relative 'PHPCodeAnalyzer'

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
        if @key.to_s == "PHP_SECTION" 
            @script.each do |line|
                stack_php = self.search_hashes(stack_php,line,linesCode,optimus_script[index])
            end
        end
        #hash = { :offset_section => optimus_script[index], :stack_php => stack_php,:file_name => file_name}
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
            stack_php.push({:token => array_list, :line_code => script[@valor[0].to_i - 1]})
        end
    end
    return stack_php
  end
end
