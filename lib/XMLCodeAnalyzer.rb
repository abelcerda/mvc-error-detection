# encoding: UTF-8
require 'parslet'
require 'pp'
class XMLParser < Parslet::Parser
  root(:webpage)
  rule(:webpage)              { xml_tag >> (double_tag.as(:DOUBLE_TAG) | single_tag.as(:SINGLE_TAG)) }
    
  rule(:comment_end)          { (str('-->').absent? >> any).repeat(1).maybe >> str('-->') }
  rule(:comment)              { str('<!--') >> comment_end  }
    
  rule(:xml_tag)              { str('<?xml') >> match('[a-zA-Z0-9: _\-,="\'\.\?]').repeat >> str('>') >> blank }
  
  rule(:content)              { ( comment | double_tag.as(:DOUBLE_TAG) | single_tag.as(:SINGLE_TAG)).repeat(1) }
  
  rule(:double_tag)           { open_tag >> blank >> content.as(:TAG_CONTENT) >> blank >> close_tag }
  rule(:open_tag)             { str('<') >> match('[a-zA-Z]').repeat(1).as(:TAG_NAME) >> blank >> ((attribute | attr_NV) >> blank ).repeat(1).as(:ATTR_LIST).maybe >> str('>') }
  rule(:close_tag)            { str('</') >> match('[a-zA-Z]').repeat(1) >> str('>') >> blank }
  
  rule(:single_tag)           { str('<') >> match('[a-zA-Z]').repeat(1).as(:TAG_NAME) >> blank >> ((attribute | attr_NV) >> blank ).repeat(1).as(:ATTR_LIST).maybe >> str('/>') >> blank }
  
  rule(:attr_value)           { attr_double_cuote | attr_simple_cuote | match('[0-9,.]').repeat(1)}
  rule(:attr_simple_cuote)    { str("'") >> match("[^']").repeat(1).as(:VALUE).maybe >> str("'") }
  rule(:attr_double_cuote)    { str('"') >> match('[^"]').repeat(1).as(:VALUE).maybe >> str('"') }
  rule(:attribute)            { (match('[a-zA-Z0-9:_-]').repeat(1).as(:ATTR) >> equal >> attr_value)}
  rule(:attr_NV)              { (match['[a-zA-Z]'].repeat(1) ) }
    
  #definiciones adicionales
  rule(:equal)                { match('=') >> blank}           
  rule(:cuote)                { match("'") | match('"') }
  rule(:space)                { match('\s').repeat(1) }
  rule(:space?)               { space.maybe }
  rule(:eol)                  { match('\n').repeat(1) }
  rule(:eol?)                 { eol.maybe }
  rule(:blank)                { space? | eol? }
  rule(:eof)                  { any.absent? }
    
end


class XMLTransformer < Parslet::Transform
  #los patterns de las rule deben contener todos los elementos (:elemento) del mismo nivel de jerarquía, de lo contrario no funcionará
  
  rule(:ATTR => simple(:y),:VALUE => simple(:x)){
    res={}
    res[y.to_s] = x.to_s
    res
  }
  
  rule(:TAG_NAME => simple(:y), :ATTR_LIST => subtree(:x)){
    # Será usada sólo por los :SINGLE_TAG porque son lo únicos que tienen estos dos elementos (:DOUBLE_TAG tiene :TAG_CONTENT, por lo cual no cumple estos requisitos)
    res={}
    res[y.to_s] = {}
    name = ''
    metrics = Hash.new
    x.each { |property|  
      if property.has_key?('name')
        name = property['name']
      end
      if !property.has_key?('name')
        metrics = metrics.merge(property)
      end
    }
    res[y.to_s][:name] = name
    res[y.to_s][:metrics] = metrics
    res
  }
  
  rule(:SINGLE_TAG => subtree(:x)){
    res = x
    res
  }
  
  rule(:TAG_NAME => simple(:z), :ATTR_LIST => subtree(:y), :TAG_CONTENT => subtree(:x)){
    # Será usada sólo por los :DOUBLE_TAG
    #    z puede ser: 'metrics', 'package', 'class', 'function'
    
    name = ''
    metrics = Hash.new
    # extracting element's name from metrics
    y.each { |property|  
      if property.has_key?('name')
        name = property['name']
      end
      if !property.has_key?('name')
        metrics = metrics.merge(property)
      end
    }
    # extracting file's name from content
    container_file = ''
    children = Array.new
    x.each { |child|
      if child.has_key?('file')
        container_file = child['file'][:name]
      end
      if !child.has_key?('file')
        children.push(child)
      end
    }
    res={}
    res[z.to_s] = {}
    res[z.to_s][:name] = name
    res[z.to_s][:container_file] = container_file
    res[z.to_s][:metrics] = metrics
    res[z.to_s][:content] = children
    res
  }
  
  rule(:TAG_NAME => simple(:y), :TAG_CONTENT => subtree(:x)){
    # Será usada sólo por los :DOUBLE_TAG que no tienen atributos (sólo es el tag 'files')
    files = Array.new
    x.each { |file|
      files.push(file['file'])
    }
    res={}
    res[:files] = files
    res
  }
  
  rule(:DOUBLE_TAG => subtree(:x)) {
    res = x
    if x.has_key?('metrics')
      res = x['metrics'][:content]
    end
    if x.has_key?('package')
      res = Hash.new
      res['package'] = x['package'][:content]
    end
    #acá se están descartando varias métricas sólo porque no están asociadas a un archivo en particular
    res
  }
  
end




class XMLAnalyzer
  
  # Zona de construcción
  # Hombres trabajando
  # TO DO: revisar las funciones de acá abajo, tal vez haya que reescribirlas, otras descartarlas. HECHO
  # TO DO: Primero corré este script tal como está y fijate los resultados que tira para saber cómo tenés que seguir con el ordenamiento por archivo. 
  # UPDATE: fijate la última función donde agrega las funciones y clases a los archivos. No lo está haciendo, pareciera que los nombres de archivo no coinciden. HECHO
  def parse_xml(xml='') #OK
    raw_metrics = get_analyzed_code(xml) #ejecutar el parser y el transformer para obtener los tags con parslet. Acá también podría transformar el nombre del tag o atributo al nombre de la métrica
    metrics_by_file = format_metrics(raw_metrics)  # recorre los tags y los ordena para que se ordenen por archivo
    return metrics_by_file
  end
  
  private

  def get_analyzed_code(xml_code='')  #OK
    result = XMLTransformer.new.apply(parse(xml_code))
    return result
  end
  
  def parse(str)
    mini = XMLParser.new

    mini.parse(str)
  rescue Parslet::ParseFailed => failure
    puts '---------- XML PROBLEMATICO'
    pp str
    puts failure.cause.ascii_tree
  end

  def format_metrics(raw_metrics) #OK
    files = get_file_list(raw_metrics)
    if !files.empty?
      classes_and_functions = find_classes_and_functions(raw_metrics)
      classes_and_functions.each do |c_or_f|
        append_classes_and_functions_to_file(c_or_f, files)
      end
    end
    return files
  end
  
  def get_file_list(metrics)  #OK
    file_array = Array.new
    if (metrics != nil && metrics[0] != nil)
      file_array = metrics[0][:files]
    end
    return file_array
  end
  
  def find_classes_and_functions(metrics) #OK
    merged_content = Array.new
    metrics.each do |tag|
      if tag.has_key?('package')
        # es un tag 'package' y ahí se guardan en un array clases y funciones, las cuales tienen a su vez el nombre del archivo al cual pertenecen
        merged_content.push(tag['package'])
      end
    end
    return merged_content.flatten(1)  #combina el array de cada paquete en uno solo con todas las clases y funciones
  end
  
  def append_classes_and_functions_to_file(c_or_f, files) #OK
    if c_or_f.has_key?('function')
      key = 'function'
    end
    if c_or_f.has_key?('class')
      key = 'class'
    end
    files.each do |file|
      if !file.has_key?(:content)
        file[:content] = Array.new
      end
      if file[:name] == c_or_f[key][:container_file]
        element = Hash.new
        element[:type] = key
        element[:name] = c_or_f[key][:name]
        element[:metrics] = c_or_f[key][:metrics]
        file[:content].push(element)
      end
    end
  end
 
end
