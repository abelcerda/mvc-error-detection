# encoding: UTF-8
require_relative 'JS-Engine'

class MVCJS
  def parse_js(code)
    js = JS_Engine.new.runJS(code.downcase) 
    res = []
    if !js.empty?   #if it not empty (empty array) then modify
      # formats the parsing results
      js.each do |jota|
        novo={}
        if jota.has_key?(:MODEL)
          novo[:COMPONENT] = "Model"
          novo[:POS] = jota[:MODEL]
        else
          if jota.has_key?(:CONTROLLER)
          novo[:COMPONENT] = "Controller"
          novo[:POS] = jota[:CONTROLLER]
          end
        end
        novo[:TYPE] = jota[:TYPE].to_s == "xmlhttprequest" ? "XMLHTTP Request" : "ActiveX Object"
        res << novo
      end
    else    #if the code returns unrelevant elements (an empty array) then delete it
#      code.delete(:JS_CODE)
    end
    res
  end
end