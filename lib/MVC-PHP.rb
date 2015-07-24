require_relative 'ScriptLexer'
require_relative 'PHP-Engine'

class MvcPhp
  @leaves = []
  @rows = []

  def getSections(code)
    sections = ScriptLexer.new.parse(code)
    optimus = Transformio.new.apply(sections)
    k = 0
    j = 0
    stack_php = []
    stack_html = []
    offset_php = [] # Array que va a contener le offset que se le sumara a los elementos del array @leaves
    sections.each_with_index do |cod,index|
      cod.select { |key, value| @ky = key; @script = value }
      if @ky.to_s == "PHP_CODE"
        aux = @script.to_s.split("@")
        stack_php[j] = aux[0]
        optimus[index].select { |key, value| @val = value } # Obtengo en la variable @val el array con la fila y la columna uqe van a ser los offset
        offset_php.push(@val[0])# Pusheo al array offset_php solamane el nro de fila que luego sera sumado a cada elemento del arreglo @leaves
        j = j + 1
      elsif @ky.to_s == "HTML_SECTION"
        aux = @script.to_s.split("@")
        stack_html[j] = aux[0]
        k = k + 1
      end
    end
    #Llamada a la clase Php_Engine que
    @leaves = PHPCodeAnalyzer.new.runPHP(stack_php,offset_php)
    return @leaves
  end
end
