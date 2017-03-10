  require 'tempfile'
  require_relative 'XMLCodeAnalyzer'
  $pdepend_command_path = './lib/MetricAnalyzer/lib/phpdepend/vendor/pdepend/pdepend/src/bin/pdepend'
  $pdepend_metric_names = {
    'ahh' => 'Average Hierarchy Height',
    'andc' => 'Average Number of Derived Classes',
    'ca' => 'Afferent Coupling',
    'calls' => 'Number of Method or Function Calls',
    'cbo' => 'Coupling Between Objects',
    'ccn' => 'Cyclomatic Complexity Number',
    'ccn2' =>'Extended Cyclomatic Complexity Number',
    'ce' => 'Efferent Coupling',
    'cis' => 'Class Interface Size',
    'cloc' => 'Comment Lines fo Code',
    'clsa' => 'Number of Abstract Classes',
    'clsc' => 'Number of Concrete Classes',
    'cr' =>  'Code Rank',
    'csz' => 'Class Size',
    'dit' => 'Depth of Inheritance Tree',
    'eloc' => 'Executable Lines of Code',
    'fanout' => 'Number of Fanouts',
    'impl' => 'Number of class implementations',
    'leafs' => 'Number of Leaf Classes',
    'lloc' => 'Logical Lines Of Code',
    'loc' => 'Lines Of Code',
    'maxDIT' => 'Max Depth of Inheritance Tree',
    'noam' => 'Number Of Added Methods',
    'nocc' => 'Number Of Child Classes',
    'noom' => 'Number Of Overwritten Methods',
    'ncloc' => 'Non Comment Lines Of Code',
    'noc' => 'Number Of Classes',
    'nof' => 'Number Of Functions',
    'noi' => 'Number Of Interfaces',
    'nom' => 'Number Of Methods',
    'npm' => 'Number of Public Methods',
    'npath' => 'NPath Complexity',
    'nop' => 'Number of Packages',
    'rcr' => 'Reverse Code Rank',
    'roots' => 'Number of Root Classes',
    'vars' => 'Properties',
    'varsi' => 'Inherited Properties',
    'varsnp' => 'Non Private Properties',
    'wmc' => 'Weighted Method Count',
    'wmci' => 'Inherited Weighted Method Count',
    'wmcnp' => 'Non Private Weighted Method Count'
  }

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
  def analyze_metrics(source_file, file_name)
    metric_file = PDependRunner.new.execute_pdepend(source_file)
    parsed_metrics = parse_xml(metric_file)
    if !parsed_metrics.empty?
      parsed_metrics = parsed_metrics[0]  # se selecciona el primer resultado porque los archivos se analizan de a uno
      parsed_metrics[:file_name] = file_name
    end
    return parsed_metrics
  end
end

#an = MetricsAnalyzer.new
#pp an.analyze_metrics('/home/abel/class.phpmailer.php')