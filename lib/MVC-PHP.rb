require_relative 'AnalyzerSection'
require_relative 'PHPCodeAnalyzer'

class MvcPhp
  @leaves = []
  @rows = []

  def getSections(code)
    sections_script = ScriptLexer.new.parse(code)
    optimus_script = Transformio.new.apply(sections_script)
   
    php_sections_analyzed = PhpLexer.new.parse(code)
    php_sections_transform = PhpTransformer.new.apply(php_sections_analyzed)

    k = 0
    j = 0
    stack_php = []
    stack_html = [] #Ya no se usa xD
    sections_php = [] # Array que va a contener le offset que se le sumara a los elementos del array @leaves

    php_sections_transform.each_with_index do |cod,index|
        stack_php = []
        cod.select { |key, value| @key = key; @script = value }
        if @key.to_s == "PHP_SECTION" 
            @script.each_with_index do |line,index|
            stack_php = self.search_hashes(stack_php,line)
        end
        hash = { "offset_section" => optimus_script[index], "stack_php" => stack_php }
        sections_php.push(hash)
        elsif @key.to_s == "HTML_SECTION"
            aux = @script.to_s.split("@")
            stack_html[k] = aux[0]
            k = k + 1
        end
    end
    #Llamada a la clase Php_Engine que
    #@leaves = PHPCodeAnalyzer.new.runPHP(stack_php,offset_php)
    return sections_php
  end

  def search_hashes(stack_php,array_list)
    if array_list.is_a?(Array)
        array_list.each do |array_aux|
            self.search_hashes(stack_php,array_aux)
        end
    else
        if array_list.is_a?(Hash)
            stack_php.push(array_list)
        end
    end
    return stack_php
  end
end
