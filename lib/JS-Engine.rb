# encoding: UTF-8
require_relative 'ecmascript'

class JS_Engine
    def runJS(code)
        parsed = TransformerEcma.new.apply(parseEcma(code))
        parsed = parsed.select { |p| !p.nil? }
        while (!parsed.empty? && !parsed[0].is_a?(Hash))  # the loop ends when finds that the array is empty or the array contains directly the hash
          parsed = parsed.flatten
        end
        parsed
    end
    
end
cadena="var ie = (function(){
				var undef,
						v = 3,
						div = document.createElement('div'),
						all = div.getElementsByTagName('i');
				while (
						div.innerHTML = '<!--[if gt IE ' + (++v) + ']><i></i><![endif]-->',
						all[0]
				);
				return v > 4 ? v : undef;
			}());"
  pp JS_Engine.new.runJS(cadena)