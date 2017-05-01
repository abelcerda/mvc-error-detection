require_relative 'PHPCodeAnalyzer'

class PHPCodeAnalyzer
  $elementsToAnalizer = ["PDO_METHODS","PDO_STATEMENT","GET","POST","REQUEST","DBA_STATEMENT"]

  def runPHP(stack,offset)
    @leaves = []
    stk_analyzed = PhpTransformer.new.apply(PhpLexer.new.parse(stack))
    pp stk_analyzed
    exit
    stack.each_with_index do |stk,index|
      stk_analyzed = PhpTransformer.new.apply(PhpLexer.new.parse(stk))
      @leaves = self.analizer_sections(stk_analyzed,@leaves,offset[index]) # Envio el offset para que sea suamdo a cada fila de las hojas ue corresponden con los tokens
    end
    return @leaves
  end

  def analizer_sections(sections,leaves,offset)
    if sections.is_a?(Array)
      leaves = self.get_hashes(sections,leaves,offset)
    end
    return leaves
  end

  def get_hashes(data,leaves,offset) #Recibe un array, data, y lo recorre xD
    i = 0
    while i < data.length
      data[i].select { |key, value| @val = value; @key = key }
      if @val.is_a?(Array)
        if $elementsToAnalizer.include?(@key.to_s) # se puede dar el caso de {:TOKEN => [x,y]}, por eso pregunto si la llave esta en el array de token que nos interesan.
          @val[0] = (@val[0] + offset) - 1
          leaves.push(data[i])
        else
          @val.each do |vl| #dado el caso {:KEY => [{},{},{}... {}]}, recorro el array y a cada hash lo pushe al array data.
            data.push(vl) #coloco al final al array para analizarlo despues
          end
        end
      else
        if @val.is_a?(Hash) # Solamente si @val es un hash se llama a get_arrays, sino se lo pasa de largo y se suma el i
          leaves,@val = self.get_arrays(@val,leaves,offset)# Recorro el hash atraves de sus hijos.
          if @val.is_a?(Array)
            @val.each do |vl|
              if vl.is_a?(Hash)
                data.push(vl)
              end
            end
          end
        end
      end
      i = i + 1
    end
    return leaves
  end

  def get_arrays(data,leaves,offset)
    while data.is_a?(Hash)
      data.select { |key, value| @val = value; @key = key }
      if $elementsToAnalizer.include?(@key.to_s)
        #Sumar el offset
        @val[0] = (@val[0] + offset) - 1
        leaves.push(data)
      end
      data = @val
    end
    return [leaves,data] # Sale del while cuando encuentra que un hijo es Array
  end
end


=begin
     file1 = params[:primero][:archivo].open()
     @rows = []
     file1.each_with_index do |line,index|
       @rows.push(line)
     end
=end
