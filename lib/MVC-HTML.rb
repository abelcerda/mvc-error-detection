# encoding: UTF-8
require_relative 'HTML-Engine'
require_relative 'MVC-JS'

class MVCHTML
  #tarea: hacer un MVC-JS para que analice el código JS encontrado en otro archivo para facilitar la
  #modularidad y escalabilidad
  def parse_HTML(code, run_js=false)
    # This method analyzes HTML code (View) from the input
    # and returns any element that doesn't belong to a view (JS code).
    # JS code is also analyzed, if found.-
    # EDIT: this library doesn't has to analyze JS in order to keep the hierarchy modular and easy to 
    # modify or add new languages/frameworks. So it has only to return HTML analyzed (Inline JS) and 
    # return all the JS code found.
    # EDIT: this method receives a parameter that indicates wether the javascript code should be saved or not.
    # This parameter is also send to se HTML_Engine in order to save memory space from the deeper layer.
    html = HTML_Engine.new.runHTML(code.downcase, run_js)
#    puts "+++"
#    pp html
#    puts "+++"
    if run_js
      if !html[1].empty?  # html[1] contains an array with all the JS scripts found between javascript-typified script tags 
  #      puts "NO JS"
  #    else
  #      puts "******* JS PARSING START *******"
        html[1].each_index do |javas|
          puts "the hut"
          pp  html[1][javas]
          if html[1][javas][:JS_CODE].is_a?(Hash)
#            puts "jotaese"
#            pp html[1][javas][:JS_CODE][:CODE]
            js = MVCJS.new.parse_js(html[1][javas][:JS_CODE][:CODE])  # it shouldn't run JS_Engine because its result is raw, instead it should be MVCJS
            if !js.empty?
              html[1][javas][:JS_CODE].delete(:CODE) #it's no longer needed
              js.each do |relativo|  # saves the global position of the relevant element instead of the relative (in the script)
                relativo[:POS][0] = html[1][javas][:JS_CODE][:POS][0] + relativo[:POS][0] - 1
              end
              html[1][javas].delete(:JS_CODE)
              js.reverse_each do |component|  # and save it into the main array
                html[1].insert(javas, component)
              end
            else    #if the code returns unrelevant elements (an empty array) then delete it
              html[1][javas].delete(:JS_CODE)
            end
          else    #is an Array. EDIT: yes it is.
            html[1][javas].delete(:JS_CODE)  # Arrays are deleted because they are always empty
          end
        end
        #    puts "******* JS PARSING END ********"
        html[1] = html[1].select{|vacio| !vacio.empty?}
      end

    end
    html
  end
end
=begin
        archivo = File.read('/media/abel/Datos/Mis Documentos/IP estatica en Linux, manualmente - Taringa!.htm')
cadena = "<html>
    <head>
        <link rel=\"stylesheet\" href=\"print.css\" type=\"text/css\" media=\"print\"/>
        <script src=\"//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js\"></script>
        <script type=\"text/javascript\" src=\"jspdf.js\"></script>
        <script type=\"text/javascript\" src=\"./libs/FileSaver.js/FileSaver.js\"></script>
        <script type=\"text/javascript\" src=\"./libs/Blob.js/BlobBuilder.js\"></script>
        <script type=\"text/javascript\" src=\"jspdf.plugin.standard_fonts_metrics.js\"></script>
        <script type=\"text/javascript\" src=\"jspdf.plugin.split_text_to_size.js\"></script>               
        <script type=\"text/javascript\" src=\"jspdf.plugin.from_html.js\"></script>
        <script>
            $(document).ready(function(){
                $('#dl').click(function(){
                var specialElementHandlers = {
                    '#editor': function(element, renderer){
                        return true;
                    }
                };
                var doc = new jsPDF('landscape');
                doc.fromHTML($('body').get(0), 15, 15, {'width': 170,   'elementHandlers': specialElementHandlers});
                doc.output('save');
                });
            });
function obtenerXHR() {
        req = false;
        if (XMLHttpRequest){
        req = new XMLHttpRequest()
        }else{
        req = new ActiveXObject('MSXML2.XMLHttp.5.0')
        }
        }
        </script>
    </head>
    <body>
        <div id='dl'>Download Maybe?</div>
        <div id='testcase'>
            <h1>  
                We support special element handlers. Register them with jQuery-style 
            </h1>
        </div>
    </body>
</html>"
=end        
#puts "ULTIMATE RESULTS------------"
#pp MVCHTML.new.parse_HTML(archivo,true)
