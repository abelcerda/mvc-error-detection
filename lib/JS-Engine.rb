
require_relative 'ecmascript'

class JS_Engine
    def runJS(code)
        javs = parseEcma(code)
        #en este espacio se debería hacer la transformaciónEcma y acomodar los tags para encontrar los elemento relevantes
        TransformerEcma.new.apply(javs)
    end
end