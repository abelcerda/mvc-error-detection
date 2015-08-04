
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