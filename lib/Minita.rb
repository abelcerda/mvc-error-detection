require 'parslet' 

class Minita < Parslet::Parser
#  rule(:tags)	    { str('html') }

#  rule(:tagopen)    { str('<') >> tags >> str('>').as(:tagO) }

#  rule(:tagclose)   { str('</') >> tags >> str('>').as(:tagC) }
  rule(:space)			{ match('\s').repeat(1) }
  rule(:space?)			{ space.maybe }
  rule(:eol)			{ match('\n').repeat(1) }
  rule(:eol?)			{ eol.maybe }
  rule(:blank)			{ space? | eol? }

  rule(:html_open)		{ str('<html>').as(:html_open)>> blank }
  rule(:html_close)		{ str('</html>').as(:html_close)>> blank }

  rule(:tag_doc)		{ str('<!DOCTYPE html>').as(:doc) >> blank }

  rule(:html_content)		{ html_open >> blank >> html_close >> blank }

  rule(:webpage)		{ tag_doc >> blank >> html_content }

  root(:webpage)
end

def parse(str)
  mini = Mini.new
  
  mini.parse(str)
rescue Parslet::ParseFailed => failure
  puts failure.cause.ascii_tree
end



class Transformer < Parslet::Transform
    #los patterns de las rule deben contener todos los elementos (:elemento) del mismo nivel de jerarquía, de lo contrario no funcionará
    rule(:doc => '<!DOCTYPE html>', :html_open => simple(:x), :html_close => simple(:y)) { 
        res = {}
        res[:hola]= String(x)   #+line
        res[:chau]= String(y)+"qw"  #+col   #con esto se convierte el valor del token a cadena
        res[:adios]= x.line_and_column      #con esto se puede obtener la ubicación del token en la cadena de entrada
        arr = []
        arr << [:hola=> String(x)]
        arr << [:chau=> String(y)]
        res[:arr] = arr
        #html_op = []
        html_op = {:token => String(x), :pos => x.line_and_column}
        res[:html_op] = html_op
        res
    }
  
end