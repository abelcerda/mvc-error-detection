  require 'tempfile'
  require_relative 'XMLCodeAnalyzer'
  $pdepend_command_path = '/home/abel/projects/git/tesis_bitbucket/tesis/lib/phpdepend/vendor/pdepend/pdepend/src/bin/pdepend'
# TO DO: mejorar la generación de la ruta. Tal vez parte de esa ruta se encuentre en la ruta de la aplicación rails


#comando = 'php pdepend \-\-summary\-xml=\/tmp\/sum.xml \/media\/abel\/Datos\/Programming\/PHP\/Curso\\ PHP\\ Ctrl+F/gramajo/'	#'php pdepend --summary-xml=/tmp/sum.xml /media/abel/Datos/Programming/PHP/Curso PHP Ctrl+F/gramajo/'

class PDependRunner
  def execute_pdepend(source_file)
    file = Tempfile.new('metrics')
    pdepend_path = $pdepend_command_path
    pdepend_options = '\-\-summary\-xml='
    command_sentence = 'php '+ pdepend_path + ' ' + pdepend_options + file.path + ' ' + source_file
    system(command_sentence)
    metric_file = File.read(file)
    # TO DO: agregar una captura de excepciones, en caso que no pueda leer el archivo que debería estar generado. YA ME PASÓ.
    file.close
    file.unlink    # deletes the temp file
    return metric_file
  end
end
  
class MetricAnalyzer < XMLAnalyzer
  def analyze_metrics(source_file)
    executer = PDependRunner.new 
    metric_file = executer.execute_pdepend(source_file)
    
    parsed_metrics = parse_xml(metric_file)
    return parsed_metrics
  end
end

#an = MetricsAnalyzer.new
#pp an.analyze_metrics('/home/abel/class.phpmailer.php')