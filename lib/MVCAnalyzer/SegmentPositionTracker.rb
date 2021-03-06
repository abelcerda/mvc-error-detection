require 'parslet'
require 'pp'

class ScriptParser < Parslet::Parser
	rule(:space)            { match('\s').repeat(1) }
	rule(:space?)           { space.maybe }
	rule(:eol)              { match('\n').repeat(1) }
	rule(:eol?)             { eol.maybe }
	rule(:blank)            { space? | eol? }
	rule(:eof)              { any.absent? }
	rule(:space_aux)        { str(" ")}

	rule(:script_body)      {(php_section.as(:PHP_SECTION) | html_section.as(:HTML_SECTION)).repeat(1).maybe >> blank }

	rule(:php_section)      { str("<?php") >> php_code >> (str("?>") | eof)}
	rule(:php_code)         { ((str("?>").absent? >> any).repeat(1)) }
	rule(:html_section)     { (str("<?php").absent? >> any).repeat(1)} 



	root(:script_body)
end

class Transformio < Parslet::Transform
	#los patterns de las rule deben contener todos los elementos (:elemento) 
	#del mismo nivel de jerarquía, de lo contrario no funcionará
	rule(:PHP_SECTION => simple(:x)) {
		resp = {}
		resp[:PHP_SECTION] = x.line_and_column
		resp
	}
	rule(:HTML_SECTION => simple(:x)) {
		resp = {}
		resp[:HTML_SECTION] = x.line_and_column
		resp
	}

end
