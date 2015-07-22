require 'pp'
require 'yaml'

require_relative 'HTMLCodeAnalyzer'

class HTML_Engine
    def runHTML
        cadena = "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
        <!-- saved from url=(0183)http://recursostic.educacion.es/observatorio/web/ca/equipamiento-tecnologico/seguridad-y-mantenimiento/803-creacion-de-un-dispositivo-de-memoria-usb-multi-arranque-formateado-con-ntfs -->

        <html xmlns='http://www.w3.org/1999/xhtml'><object type='{0C55C096-0F1D-4F28-AAA2-85EF591126E7}' cotype='cs' id='cosymantecbfw' style='width: 0px; height: 0px; display: block;'></object><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><HEAD><br onclick='do something()'> <script> 
        $(document).ready(function(){ //cuando el html fue cargado iniciar

            //aado la posibilidad de editar al presionar sobre edit
            $('#cancel').live('click',function(){
                $('#block').hide();
            })
        })
        algo
        {}
        NS={};
        function obtenerXHR() {
        req = false;
        if (XMLHttpRequest){
        req = new XMLHttpRequest()
        }else{
        req = new ActiveXObject('MSXML2.XMLHttp.5.0')
        }
        }
            document.getElementById('myButton').onclick = function(){
                    alert('Hello!');
                };
        req = new XMLHttpRequest()




        </script><br onclick='do something()'>
        <script>
function openIEalert()
			{
				var ventana = document.getElementById('ie7alert');
				ventana.style.marginTop = '100px';
				ventana.style.left = ((document.body.clientWidth-350) / 2) +  'px';
				ventana.style.display = 'block';
			}

			function closeIEalert()
			{
				var ventana = document.getElementById('ie7alert');
				ventana.style.display = 'none';
			}
		
			var ie = (function(){
				var undef,
						v = 3,
						div = document.createElement('div'),
						all = div.getElementsByTagName('i');
				//while (
				//		div.innerHTML = '<!--[if gt IE ' + (++v) + ']><i></i><![endif]-->',
				//		all[0]
				//);
				return v > 4 ? v : undef;
			}());
			
			//check version
			if(ie < 8 && ie !== 'undefined'){
				openIEalert();
			}
        </script>
        </head>"
        archivo = File.read('/media/abel/Datos/Mis Documentos/IP estatica en Linux, manualmente - Taringa!.htm')
        id = Mini.new.parse(cadena.downcase)
        #pp id
#        puts "----HTML-Engine START----"
        #pp id[0][:SCRIPT_EMBEDDED][:NOSCR].to_str
        optimus= Transformer.new.apply(id)
#        pp optimus
#        puts optimus.size
        final=[]    #la posición 0 será para los JS_INLINE y la 1 para los código JS que deberán ser analizados
        final << []
        final << []
        optimus.each do |resto|
            if resto
                if resto.has_key?(:JS_INLINE)
                    final[0] << resto[:JS_INLINE]
                else
                    final[1] << resto
                end
            end
        end
#        puts "----HTML-Engine END----"
#        pp final
        final
    end
end