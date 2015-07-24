require 'parslet'
require 'pp'

class ScriptLexer < Parslet::Parser
	  rule(:space)			{ match('\s').repeat(1) }
    rule(:space?)			{ space.maybe }
    rule(:eol)			    { match('\n').repeat(1) }
    rule(:eol?)			    { eol.maybe }
    rule(:blank)			{ space? | eol? }
    rule(:eof)              { any.absent? }
    rule(:space_aux)        { str(" ")}

    rule(:script_body)      {(php_section | html_section.as(:HTML_SECTION)).repeat >> blank }

    rule(:php_section)      { str("<?php") >> php_code.as(:PHP_CODE).maybe >> (str("?>") | eof)}
    rule(:php_code)         { ((str("?>").absent? >> any).repeat(1)) }
    rule(:html_section)		{ (str("<?php").absent? >> any).repeat(1)} #<?php



	root(:script_body)
end

class Transformio < Parslet::Transform
    #los patterns de las rule deben contener todos los elementos (:elemento) del mismo nivel de jerarquía, de lo contrario no funcionará
    rule(:PHP_CODE => simple(:x)) {
        resp = {}
        resp[:PHP_CODE] = x.line_and_column
        resp
    }
    rule(:HTML_SECTION => simple(:x)) {
        resp = {}
        resp[:HTML_SECTION] = x.line_and_column
        resp
    }

end


=begin
def parse(str)
  mini = ScriptLexer.new

  mini.parse(str)
rescue Parslet::ParseFailed => failure
  puts failure.cause.ascii_tree
end

string = "$fields[$field->name] = $field->value;
        $response->response = '[accepted]';"
archivo = File.read('/home/clifford/Documentos/archivos_prueba/php_test20.php')
#puts archivo.downcase
id = parse archivo.downcase
puts id
puts"*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
optimus = Transformio.new.apply(id)
pp optimus
#pp optimus[1][:HTML_SECTION]
=end
