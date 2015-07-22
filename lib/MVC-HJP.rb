require_relative 'HTML-Engine'
require_relative 'JS-Engine'

html = HTML_Engine.new.runHTML
#puts "now showing HTML"
#pp html
if html[1].empty?
    puts "NO JS"
else
    puts "******* JS PARSING START *******"
    html[1].each do |javas|
        puts "este es JAVAS"
        pp javas
        js = JS_Engine.new.runJS(javas[:JS_CODE][:CODE])
        puts "javas analizado"
        pp js
        javas[:JS_CODE] = {}
        javas[:JS_CODE] = js
    end
    puts "******* JS PARSING END ********"
end

puts "ULTIMATE RESULTS------------"
pp html
