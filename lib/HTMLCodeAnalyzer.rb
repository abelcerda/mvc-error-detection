# encoding: UTF-8
require 'parslet'
require 'pp'
#require_relative 'lexems'
#require_relative 'JSCodeAnalyzer'

class ScriptParser < Parslet::Parser
    root(:script_tag_section)
    rule(:noscript)             { (str("</script>").absent? >> any).repeat(1).maybe }
    rule(:script_tag_section)   { script_tag_open >> noscript.as(:CODE) >> script_tag_close }
    rule(:script_tag_open)	    { (str('<script') >> blank >> script_attribute? >> str('>')) >> blank }    
    rule(:script_attribute?)    { script_attribute.repeat(1).maybe }    
    rule(:script_attribute)     { script_attr_type >> equal >> cuote >> script_attr_value.as(:SCR_VAL) >> cuote >> blank }    #hay que controlar que si se abren comillas simples los valores deben aceptar las comillas dobles y viceversa
    rule(:script_attr_type)     { (str('src').as(:SRC) | str('type').as(:TYPE) | anyattribute) >> blank }   #agregar la regla de atributos personalizados de :attributes    
    rule(:anyattribute)         { match('[a-z0-9:_-]').repeat}  #el .as(:VALUE) sólo es para prueba e irrelevante.
    rule(:script_attr_value)    { match('[a-z0-9 .%&$?!/\=:_-]').repeat }  
    rule(:script_code?)         { script_code.as(:SCRIPT_EMBEDDED).maybe }   #ARREGLAR POR AQUÍ POR CULPA DE LA LINEA 1535 
    rule(:script_code)          { MiniJS.new}#{ (logical_ang.as(:LOG_ANG) | string_in_script | match('[^(){}<]')).repeat(1) }#{ (script_tag_close.absent? >> any).repeat(1) }    # corregir esta línea porque hay código como div.innerHTML = '<!--[if gt IE ' + (++v) + ']><i></i><![endif]-->'. Se me ocurre definir reglas para cadenas que entre cuotes acepte cualquier cosa (any)
    rule(:string_in_script)     { str("'") >> match("[^']").repeat(1) >> str("'") >> script_code }     #sirve para contemplar la opción de un < en una cadena dentro de un script
    rule(:logical_ang)          { str('\{') >> str("\}").absent? >> script_code >> str('\}') |
                                str('\(') >> str("\)").absent? >> script_code >> str('\)') }#{ identifier >> blank >> (str('<')|str('>')) >> blank >> identifier >> script_code?}     #sirve para contemplar la opción de un < en una comparación lógica dentro de un script
    rule(:identifier)           { match('[a-z0-9]').repeat(1) }
    rule(:script_tag_close)	    { str('</script>') >> blank }
    
    
    rule(:equal)                { match('=') >> blank}           
    rule(:cuote)                { match("'") | match('"') }  #eliminar el .as. No se pueden poner un .as para una conjunción OR ( | )
    rule(:space)                { match('\s').repeat(1) }
    rule(:space?)               { space.maybe }
    rule(:eol)                  { match('\n').repeat(1) }
    rule(:eol?)                 { eol.maybe }
    rule(:blank)			    { space? | eol? }
end    

class Mini < Parslet::Parser
    #falta reconocer acentos, ñ, ¡, ¿ y demás caracteres especiales
    root(:webpage)              
    rule(:webpage)              { comment.maybe >> doc_tag >> content }
    
    rule(:comment_end)          { (str('-->').absent? >> any).repeat(1).maybe >> str('-->') }#{ str('-->') | any >> comment_end }
    rule(:comment)              { str('<!--') >> comment_end  }
    
    rule(:doc_tag)              { str('<!doctype html') >> match('[a-z0-9 /"\'.,:_-]').repeat >> str('>') >> blank }
    rule(:script)               { ScriptParser.new.as(:SCRIPT_EMBEDDED) }
    rule(:content)              { ( comment | script | single_tag.as(:SINGLE_TAG) | double_tag.as(:DOUBLE_TAG) | text ).repeat }
    
    #definición de las reglas de etiquetas HTML
#    rule(:tag_section)          { single_tag | double_tag }
    rule(:single_tag)           { str('<') >> (str('br') | str('link') | str('meta') | str('img') | str('input')) >> blank >> ((script_inline.as(:SCRIPT_INLINE) | attribute | attr_NV) >> blank ).repeat(1).maybe >> str('/').maybe >> str('>') }   #la barra lateral es recomendable para etiquetas simples, pero no es necesaria en HTML5
    rule(:double_tag)              { (str('</') | str('<')) >> match['[a-z0-9]'].repeat(1) >> blank >> ((script_inline.as(:SCRIPT_INLINE) | attribute | attr_NV) >> blank ).repeat(1).maybe >> str('>') >> blank}
    #rule(:attr_list)            { (script_inline.as(:SCRIPT_INLINE) | attribute | attr_NV) >> blank } # en desuso porque si se utiliza esta regla en la de tags, la etiqueta de script_inline depende de los attr_list pero también se mostrarán los atributos que no son script. Difícil de explicar de forma sencilla, si no me crees probalo y comprobalog
    rule(:script_inline)        { (inlineEH >> equal >> (attr_double_cuote | attr_simple_cuote))}
    rule(:inlineEH)             { str('onafterprint') | str('onbeforprint') | str('onbeforeunload') | str('onerror') | str('onhashchange') | str('onload') | str('onmessage') | str('onoffline') | str('ononline') | str('onpagehide') | str('onpageshow') | str('onpopstate') | str('onresize') | str('onstorage') | str('onunload') | str('onblur') | str('onchange') | str('oncontextmenu') | str('onfocus') | str('oninput') | str('oninvalid') | str('onreset') | str('onsearch') | str('onselect') | str('onsubmit') | str('onkeydown') | str('onkeypress') | str('onkeyup') | str('onclick') | str('ondblclick') | str('ondrag') | str('ondragend') | str('ondragenter') | str('ondragleave') | str('ondragover') | str('ondragstart') | str('ondrop') | str('onmousedown') | str('onmousemove') | str('onmouseout') | str('onmouseover') | str('onmouseup') | str('onmousewheel') | str('onscroll') | str('onwhell') | str('oncopy') | str('oncut') | str('onpaste') | str('onabort') | str('oncanplay') | str('oncanplaythrough') | str('oncuechange') | str('ondurationchange') | str('onemptied') | str('onended') | str('onerror') | str('onloadeddata') | str('onloadedmetadata') | str('onloadstart') | str('onpause') | str('onplay') | str('onplaying') | str('onprogress') | str('onratechange') | str('onseeked') | str('onseeking') | str('onstalled') | str('onsuspend') | str('ontimeupdate') | str('onvolumechange') | str('onwaiting') | str('onshow') | str('ontoggle') }   #ref. http://www.w3schools.com/tags/ref_eventattributes.asp
    rule(:attr_value)           { attr_double_cuote | attr_simple_cuote | match('[0-9,.]').repeat(1)}
    rule(:attr_simple_cuote)    { str("'") >> match("[^']").repeat(1).maybe >> str("'") } #encontré sitios con valores con el siguiente formato <span id="citar_comm_"><%= strtotime %></span> o src="<%= avatar %> o [Ctrl+B] (corchetes)"
    rule(:attr_double_cuote)    { str('"') >> match('[^"]').repeat(1).maybe >> str('"') }
    rule(:attribute)            { (match('[a-z0-9:_-]').repeat >> equal >> attr_value)}  #el .as(:VALUE) sólo es para prueba e irrelevante.
    rule(:attr_NV)              { (match['[a-z]'].repeat(1) ) }
    
    #definición del texto en general
    rule(:text)                 { match('[^<]').repeat(1) }#{ any } porque el texto puede tener llaves angulares
    
    rule(:text?)			    { text.maybe }
    
    #definiciones adicionales
    rule(:equal)                { match('=') >> blank}           
    rule(:cuote)                { match("'") | match('"') }  #eliminar el .as. No se pueden poner un .as para una conjunción OR ( | )
    rule(:space)                { match('\s').repeat(1) }
    rule(:space?)               { space.maybe }
    rule(:eol)                  { match('\n').repeat(1) }
    rule(:eol?)                 { eol.maybe }
    rule(:blank)			    { space? | eol? }
    
end

def parse(str)
  mini = Mini.new
  
  mini.parse(str)
rescue Parslet::ParseFailed => failure
  puts failure.cause.ascii_tree
end

cadena = "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
<!-- saved from url=(0183)http://recursostic.educacion.es/observatorio/web/ca/equipamiento-tecnologico/seguridad-y-mantenimiento/803-creacion-de-un-dispositivo-de-memoria-usb-multi-arranque-formateado-con-ntfs -->

<html xmlns='http://www.w3.org/1999/xhtml'><object type='{0C55C096-0F1D-4F28-AAA2-85EF591126E7}' cotype='cs' id='cosymantecbfw' style='width: 0px; height: 0px; display: block;'></object><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><HEAD> <script> 
$(document).ready(function(){ //cuando el html fue cargado iniciar

    //aado la posibilidad de editar al presionar sobre edit
    $('#cancel').live('click',function(){
        $('#block').hide();
    })
})
algo
{}
NS={};
</script></head>
<!-- saved from url=(0087)http://www.taringa.net/posts/downloads/7013444/Norton-Ghost-15-booteable-desde-USB.html -->
		<!--[if IE]><link href='http://o1.t26.net/img/ie.min.css?39' rel='stylesheet'><link href='http://o1.t26.net/img/iefix.min.css?39' rel='stylesheet><![endif]-->
<body> hola
    // nuevo que pueda aparecer
<script src = 'app.js'     ></script>
<p onmouseover='alert()'>Hacer Clic</p>
<li><a href='http://recursostic.educacion.es/observatorio/web/ca/internet' class='images'>Internet</a></li>
<li><a href='http://recursostic.educacion.es/observatorio/web/ca/software' class='images'>Software</a></li>
<table border=5 onclick='alert()'><td>hola borde 5</td></table><input type='text' required >
</body>
</html>"	# tiene problemas con la ñ y con los atributos sin valores <input type="text" required />
#puts cadena
#id = parse cadena.downcase
#archivo = File.read('/media/abel/Datos/Mis Documentos/IP estatica en Linux, manualmente - Taringa!.htm')
#archivo = '<!DOCTYPE html> <!-- saved from url=(0087)http://www.taringa.net/posts/linux/10184297/Comandos-Utiles-para-redes-IP-en-Linux.html --> 
#<html xmlns="http://www.w3.org/1999/xhtml" lang="es" xml:lang="es"> "hola"</html>'
#id = parse archivo.downcase
#puts id
b=[]
x=0
y=0
#id.each do |element|
#    if element[:SCRIPT_EMBEDDED]
#        b << element[:SCRIPT_EMBEDDED].line_and_column
#        x=x+1
#    end
#    if defined? element[:ATTR_LST]
#        #if element[:ATTR_LST][0][:SCRIPT_INLINE]
#        #b << element[:SCRIPT_EMBEDDED].line_and_column
#        if defined? element[:ATTR_LST][0]
#            if defined? element[:ATTR_LST][0][:SCRIPT_INLINE]
#                y = y+1
#            end
#        end
#    end
#end
#puts id.length
#pp b
class Transformer < Parslet::Transform
    #los patterns de las rule deben contener todos los elementos (:elemento) del mismo nivel de jerarquía, de lo contrario no funcionará
    rule(:SCRIPT_INLINE => simple(:x)) { 
        res = {}
        #res[:hola]= String(x)   #+line
        #res[:chau]= String(y)+"qw"  #+col   #con esto se convierte el valor del token a cadena
        res[:SCRIPT_INLINE]= x.line_and_column      #con esto se puede obtener la ubicación del token en la cadena de entrada
        #arr = []
        #arr << [:hola=> String(x)]
        #arr << [:chau=> String(y)]
        #res[:arr] = arr
        #html_op = []
        #html_op = {:token => String(x), :pos => x.line_and_column}
        #res[:html_op] = html_op
        res
    }
#    rule(:SCRIPT_EMBEDDED => simple(:x)) { #WORKS
#        res = {}
#        res[:SCRIPT_EMBEBIDO]={}
#        #res[:hola]= String(x)   #+line
#        #res[:chau]= String(y)+"qw"  #+col   #con esto se convierte el valor del token a cadena
#        res[:SCRIPT_EMBEBIDO][:POS]= x.line_and_column      #con esto se puede obtener la ubicación del token en la cadena de entrada
#        res[:SCRIPT_EMBEBIDO][:CODE] = x
#        #arr = []
#        #arr << [:hola=> String(x)]
#        #arr << [:chau=> String(y)]
#        #res[:arr] = arr
#        #html_op = []
#        #html_op = {:token => String(x), :pos => x.line_and_column}
#        #res[:html_op] = html_op
#        res
#    }

    rule(:CODE => simple(:x)){
        if x
            res={}
            res[:CODE] = x.to_s
            res[:POS] = x.line_and_column
            res
        end
    }
    
    rule(:SCRIPT_EMBEDDED => subtree(:x)) { # WORKS
     if x
        res = {}
        if (x.size) #controla que esta rama tenga elementos
            i=0
            no_type = true
            no_src = true
            y=[]
            #A LO QUE SIGUE, que sí funciona, HAY QUE CONTROLAR PRIMERO SI EXISTE EL ATRIBUTO TYPE.
            #SI NO EXISTE, ENTONCES PASA DERECHO Y SÍ SE GUARDA EL CÓDIGO.
            #SI EXISTE, ENTONCES HAY QUE CONTROLAR QUE SEA JAVASCRIPT
            #se comprueba si se trata de una llamada a un source script
            while ((i<x.size) && no_type && no_src)
                if (defined? x[i][:TYPE].size)
                    no_type = false
                end
                if (defined? x[i][:SRC].size)
                    no_src = false
                end
                if no_type && no_src
                    i = i + 1
                end
            end
            if no_src
                if no_type # esta rama no tiene el atributo TYPE especificado, entonces por defecto es JS
                    y = x
                else    #esta rama tiene especificado el atributo TYPE, entonces se debe controlar si es o no JS
                    if (x[i][:SCR_VAL].to_s == "text/javascript")
                        y = x
                    end
                end
#            if (defined? x[0][:SCR_VAL].size)  #   WORKS!
#                if ((x[0][:SCR_VAL].to_s == "text/javascript")||(x[0][:SCR_VAL].to_s == ""))
#                    y=x
##                    if (defined? x[0][:CODE].size)
#                        
##                else
##                    y="NONONO"
#                end
#                i=i+1
#            end
                res[:JS_CODE]=y
            end
#            res["i"]=i
#            res["inc"]=innocent
        end
        res
     end
    }
    
    rule(:SINGLE_TAG => subtree(:x)) {
        if defined? x[0][:SCRIPT_INLINE]
            res = {}
            res[:JS_INLINE] = {}
            res[:JS_INLINE][:COMPONENT] = "Controller"
            res[:JS_INLINE][:TYPE] = "Inline Javascript"
            res[:JS_INLINE][:POS] = x[0][:SCRIPT_INLINE]
            res
        end
    }
    rule(:DOUBLE_TAG => subtree(:x)) {
        if defined? x[0][:SCRIPT_INLINE] 
            res = {}
            res[:JS_INLINE] = {}
            res[:JS_INLINE][:COMPONENT] = "Controller"
            res[:JS_INLINE][:TYPE] = "Javascript"
            res[:JS_INLINE][:POS] = x[0][:SCRIPT_INLINE]
            res
        end
    }
  
end

#optimus = Transformer.new.apply(id)
#pp optimus
#pp x, y
# the HTML handler (upper abstraction level) should run this script and then read it. When reading, every time it founds a :SCRIPT_EMBEBIDO element should run the ecmascript.rb script and add the results to such element. This results could be position and type of XMLHttp and also erase the analyzed JS code