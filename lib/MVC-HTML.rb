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
    if run_js
      if !html[1].empty?  # html[1] contains an array with all the JS scripts found between javascript-typified script tags 
  #      puts "NO JS"
  #    else
  #      puts "******* JS PARSING START *******"
        html[1].each do |javas|
          if javas[:JS_CODE].is_a?(Hash)
            js = MVCJS.new.parse_js(javas[:JS_CODE][:CODE])  # it shouldn't run JS_Engine because its result is raw, instead it should be MVCJS
            if !js.empty?
              javas[:JS_CODE].delete(:CODE)
              javas[:JS_CODE][:PARSED] = js
            else    #if the code returns unrelevant elements (an empty array) then delete it
              javas.delete(:JS_CODE)
            end
          else    #is an Array. EDIT: yes it is.
            javas.delete(:JS_CODE)  # Arrays are deleted because they are always empty
          end
        end
        #    puts "******* JS PARSING END ********"
        html[1] = html[1].select{|vacio| !vacio.empty?}
      end

    end
    html
  end
end
        archivo = File.read('/media/abel/Datos/Mis Documentos/IP estatica en Linux, manualmente - Taringa!.htm')

#puts "ULTIMATE RESULTS------------"
pp MVCHTML.new.parse_HTML(archivo,true)
