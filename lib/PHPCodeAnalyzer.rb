require 'parslet'
require 'pp'

class PhpLexer < Parslet::Parser
	rule(:space)			{ match('\s').repeat(1) }
    rule(:space?)			{ space.maybe }
    rule(:eol)			    { match('\n').repeat(1) }
    rule(:eol?)			    { eol.maybe }
    rule(:blank)			{ space? | eol? }
    rule(:eof)              { any.absent? }
    rule(:space_aux)        { str(" ")}

    #rule(:script_body)      {(html_section | php_section) >> blank }

    #rule(:php_section)      { php_tag(close: false).as(:PHP_OPEN) >> blank >> php_code.as(:PHP_CODE) >> blank >> str("?>").as(:PHP_CLOSE) }

    #rule(:script_tag_section)   { script_tag_open >> noscript.as(:CODE) >> script_tag_close }

    rule(:php_code)         {blank >> (control_structure.as(:CONTROL_STRUCTURE) | pdo_statement | class_definition.as(:CLASS) | coment.as(:COMENT) |
    						define_function.as(:FUNCTION) | exceptions.as(:EXCEPTION) | interafaces.as(:INTERFACES) |
                            one_line_statement.as(:ONE_LINE_STATEMENT)).repeat >> blank}

 #   rule(:php_code) 		{ dowhile_statement.as(:DOWHILE) >> blank }

    rule(:control_structure){ (while_statement.as(:WHILE) | if_statement.as(:IF) |
    						 dowhile_statement.as(:DO_WHILE) | foreach_statement.as(:FOREACH) |
                             for_statement.as(:FOR)| switch_statement.as(:SWITCH)) >> blank}

    rule(:one_line_statement){ (namespace.as(:NAMESPACE) | var_assignment | global_vars.as(:G_VARS) |
                            internal_function | require_statement.as(:REQUIRE) | increment_decrement.as(:INC_DEC) | class_atributte |
                            printers.as(:PRINT) | return_sentence.as(:RETURN) |
                            continue.as(:CONTINUE)) >> str(";").maybe >> blank }
#--------------- DBA statement ------------------
	rule(:dba_statement)    { (str("dba_open") | str("dba_exists") | str("dba_close") |
                            str("dba_fetch") | str("dba_firstkey") | str("dba_delete") |
                            str("dba_handlers") | str("dba_insert") |
                            str("dba_key_split") | str("dba_list") |
                            str("dba_optimize") | str("dba_sync") |
                            str("dba_replace") | str("dba_popen")) >> blank}
#------------------------------------------------


#--------------- PDO statement ------------------
	rule(:pdo_statement)    { ((str("new pdo")) >> blank >> str("(") >> blank >>
                            parameters >> blank >> str(")").maybe) >> blank }
    rule(:pdo_methods)      { (str("query") | str("execute") |
                            str("fetchall") | str("fetchcolumn") |
                            str("fetch") | str("getattribute") |
                            str("getcolumnmeta") | str("nextrowset") |
                            str("rowcount") | str("setattribute") |
                            str("setfetchmode") | str("bindcolumn") |
                            str("bindparam") | str("bindvalue") |
                            str("closecursor") | str("columncount") |
                            str("debugdumpparams") | str("errorcode") |
                            str("errorinfo")) >> blank >> str("(") >>
                            parameters >> blank >> str(")").maybe >> blank}
#-----------------------------------------------

#---------------- EXCEPTION -----------------------
    rule(:exceptions)       { (tryCatch.as(:TRY_CATCH) | thrown.as(:throw)) >> blank }
    rule(:tryCatch)       { (str("try") >> blank >> str("{") >> blank >> php_code.maybe >> blank >> str("}") >> blank >>
                            ((str("catch") >> blank >> str("(") >> blank >> catch_conditions >> blank >>
                            str(")") >> blank >> str("{") >> blank >> php_code.maybe >> blank >> str("}") >> blank).as(:CATCH) |
                            (str("finally") >> blank >> str("{") >> blank >> php_code.maybe >> blank >>
                            str("}")).as(:FINALLY) >> blank).repeat(1)) >> blank}
    rule(:catch_conditions) { (simple_string >> blank >> simple_string) >> blank }
    rule(:thrown)           { str("throw") >> blank >> str("new") >> blank >> internal_function >> str(";").maybe >> blank}
#--------------------------------------------------

#------------------- if ---------------------------
    rule(:if_statement)     { if_one_line.as(:IF_ONE_LINE) | if_normal_form.as(:NORMAL_FORM) |
                            if_short_form.as(:SHORT_FORM)}
    rule(:if_normal_form)   {(str("if") >> blank >> expresions >> blank >> str(")").repeat.maybe
                            coment.as(:IF_COMENT).maybe >> blank >> str("{") >> blank >> php_code.maybe >> blank >>
                            str("}") >> blank >> coment.as(:IF_COMENT).maybe >> blank >> (((str("elseif") |
                            str("else if")) >> blank >> expresions.as(:OPERATION_ELSE) >> blank >> str("{") >> blank >>
                            php_code >> blank >> str("}") >> blank >> else_normal_form.maybe >> blank) |
                            else_normal_form | else_one_line).repeat.maybe) >> blank}

    rule(:if_short_form)    {(str("if") >> blank >> expresions.as(:IF_OPERATIONS) >> blank >> str(":") >> blank >>
                            php_code >> blank >> ((str("endif;") >> blank) | else_short_form |
                            ((str("elseif") | str("else if")) >> blank >> expresions.as(:OPERATION_ELSE) >> blank >>
                            php_code >> blank >> ((str("endif;") >> blank >> coment.as(:COMENT_IF).maybe) |
                            else_short_form) >> blank)).maybe)  >> blank }
    rule(:if_one_line)      {(str("if") >> blank >> expresions.as(:OPERATIONS) >> blank >> coment.as(:COMENT_IF).maybe >>
                            blank >> only_sentence >> blank >> (else_one_line).maybe) >> blank}

    rule(:else_normal_form) { str("else") >> blank >> coment.as(:ELSE_COMENT).maybe >> blank >> str("{") >>
                            blank >> php_code >> blank >> str("}") >> blank }
    rule(:else_short_form)  { (str("else") >> blank >> str(":") >> blank >> php_code >> blank >> str("endif;") >>
                            blank >> coment.as(:COMENT_IF).maybe) >> blank }
    rule(:else_one_line)    { str("else") >> blank >> only_sentence >> blank }
#--------------------------------------------------

#-------------------- Functions -------------------
    rule(:function_statement){ simple_string >> str("(") >> blank >> parameters.maybe >> blank >> str(")") >> blank >>
                            str(";").maybe >> blank >> coment.as(:COMENT_FUNCTION).maybe >> blank }
    rule(:define_function)  { str("function") >> blank >> simple_string >> blank >> str("(") >> blank >>
                            parameters.maybe >> blank >> str(")").maybe >> blank >>
                            coment.as(:COMENT_FUNCTION).maybe >> blank >> str("{") >> blank >> php_code.maybe >> blank >>
                            str("}") >> blank}
    rule(:require_statement){ ((str("require") | str("include") | str("require_once") | str("include_once")) >>
                            blank >> str("(").maybe >> blank >> (cadenas | simple_string) >> blank >>
                            str(")").maybe) >> blank }
    rule(:declare_statement){ str("declare") >> str("(") >> (variable >> blank >>operators >> blank >> variable) >>
    						str(")") >> blank >> str(";").maybe >> blank >> (var_assignment | control_structure ) >>
    						blank >> str("}") >> blank }
    #Un parametro puede ser una operacion, por ejemplo: $i." ".$j... :/
#--------------------------------------------------

#---------------------- For -----------------------
    rule(:for_statement)    { for_normal.as(:FOR_NORMAL) | for_alternative.as(:FOR_ALTERNATIVE)}
    rule(:for_normal)       { (str("for") >> blank >> str("(") >> blank >> for_conditions.as(:CONDITIONS) >> blank >> str(")") >> blank >>
                            coment.as(:FOR_COMENTS).maybe >> blank >> str("{") >> blank >> php_code.maybe >> blank >>
                            str("}")) >> blank }
    rule(:for_alternative)  { (str("for") >> blank >> str("(") >> for_conditions >> str(")") >> blank >> php_code >>
    						blank >> str("endfor;") >> coment.as(:COMENT_FOR).maybe) >> blank }
#    rule(:for_conditions)   { ((variable >> blank >> operators >> blank >> variable).maybe >> blank >> (str(";") |
#                           str(","))).repeat(1) >> blank >> increment_decrement.maybe } #Revisar el tema de las operaciones, por ejemplo: print f;
    rule(:increment_decrement){ ((str("--") | str("++")) >> variable) | (variable >> (str("--") | str("++"))) >> blank}
    rule(:for_conditions)   { (parameters.maybe >> blank >> str(";")).repeat(2) >> blank >> increment_decrement.maybe }
#--------------------------------------------------

#-------------------- Switch ----------------------
    rule(:switch_statement) {(swt_normal_syntax.as(:SWT_NORMAL_SYNTAX) |
    						swt_alternative_syntax.as(:SWT_ALTERNATIVE_SYNTAX)) >> blank }
    rule(:swt_normal_syntax){str("switch") >> blank >> (operation | str("(") >> blank >> variable >> blank >>
    						str(")")) >> blank >> str("{") >> blank >> coment.as(:COMENT_SWITCH).maybe >> blank >>
    						switch_case.repeat >> blank >> switch_default.maybe >> blank >> str("}") >> coment.as(:COMENT_SWITCH).maybe}
    rule(:swt_alternative_syntax){ str("switch") >> blank >> (operation | str("(") >> blank >> variable >> blank >>
    						str(")")) >> blank >> str(":") >> blank >> coment.as(:COMENT_SWITCH).maybe >> blank >>
    						switch_case.repeat >> blank >> str("endswitch;") >> coment.as(:COMENT_SWITCH).maybe }
    rule(:switch_case)      {(str("case") >> blank >> variable >> blank >> str(":") >> blank >>
    						php_code.maybe >> blank >> str("break;").maybe >> blank) }
    rule(:switch_default)   { (str("default") >> blank >> str(":") >> blank >> php_code) >> blank }
#--------------------------------------------------

#-------------------- ForEach ---------------------
    rule(:foreach_statement){(feach_normal_syntax.as(:FOREACH_NORMAL_SYNTAX) |
    						feach_alternative_syntax.as(:FOREACH_ALTERNATIVE_SYNTAX)) >> blank}
    rule(:feach_normal_syntax){ str("foreach") >> blank >> str("(") >> blank >> (var_array.as(:ARRAY) | variable) >>
    						blank >> str("as") >> blank >> value_foreach >> blank >> str(")") >> blank >>
                            coment.as(:FOREACH_COMENT).maybe >> blank >> str("{") >> blank >> php_code >> blank >>
                            str("}") >> blank }
    rule(:feach_alternative_syntax){ str("foreach") >> blank >> str("(") >> blank >> (var_array.as(:ARRAY) | variable) >>
    						blank >> str("as") >> blank >> value_foreach >> blank >> str(")") >> blank >>
                            coment.as(:FOREACH_COMENT).maybe >> str(":") >> blank >> php_code >> blank >> str("endforeach;") >>
                            blank }
    rule(:var_array)        {(array_multiple_positions.as(:ARRAY_MULTIPLE_POSITIONS) |
    						array_one_position.as(:ARRAY_ONE_POSITION)) >> blank }
    rule(:array_multiple_positions){ (str("array") >> blank >> str("(") >> blank >> (array_content | variable) >> blank >>
    						str(")")) >> blank }
    rule(:array_one_position){ ((str("$_post").as(:POST) | str("$_get").as(:GET) | str("array") | simple_string) >> (str("[") >> blank >>
                            (operation | internal_function | class_atributte | cadenas | variable).maybe >> blank >> str("]")).repeat(1)) >> blank }
    rule(:array_content)    { asociative_array.as(:ASOC_ARRAY) | elements_array.as(:SIMPLE_ARRAY) }
    rule(:elements_array)   { (((var_array | variable) >> blank >> str(",") >> ((blank >> coment >> blank) | blank)).repeat(1) >> blank >>
    						(var_array | variable)) >> blank }
    rule(:value_foreach)    { (asociative_array | variable) }
    rule(:asociative_array) { ((class_atributte | cadenas | simple_string) >> blank >> str("=>") >> blank >> (class_atributte |
                            var_array | internal_function | operation | variable) >> blank >> str(",") >>
                            ((blank >> coment >> blank) | blank)).repeat.maybe >> ((class_atributte | cadenas | simple_string) >>
                            blank >> str("=>") >> blank >> (var_array | internal_function | operation | variable)) >> blank }
#--------------------------------------------------

#------------------ Interfaces --------------------
    rule(:interafaces)          { str("interfaces") >> blank >> simple_string >> blank >> str("{") >>
                            blank >> interfaces_content.repeat(1) >> blank >> str("}") >> blank}
    rule(:interfaces_content)   { str("public").maybe >> blank >> str("function") >> blank >> internal_function >> blank}

#--------------------------------------------------

#------------------- Do While ---------------------
    rule(:dowhile_statement){(str("do") >> blank >> coment.as(:DO_WHILE_COMENT).maybe >> blank >> str("{") >> blank >>
                            php_code.maybe >> blank >> str("}") >> blank >> str("while") >> blank >> ((str("(") >>
                            blank >> variable >> blank >> str(")")) | operation.as(:DO_WHILE_OPERATION)) >>
                            str(";")) >> coment.as(:COMENT_DOWHILE).maybe >> blank}
#--------------------------------------------------

#------------------- While ------------------------
    rule(:while_statement)  { while_normal_syntax.as(:WHILE_NORMAL) | while_alternative_syntax.as(:WHILE_ALTERNATIVE)}
    rule(:while_normal_syntax){ str("while") >> blank >> expresions.as(:WHILE_OPERATION) >> blank >>
                            coment.as(:WHILE_COMENT).maybe >> blank >> str("{") >> blank >> php_code >> blank >>
                            str("}") >> blank}
    rule(:while_alternative_syntax) { str("while") >> blank >> expresions.as(:WHILE_OPERATION) >> blank >>
                            coment.as(:WHILE_COMENT).maybe >> blank >> str(":") >> blank >> php_code >> blank >>
                            str("endwhile;") >> blank }
#--------------------------------------------------

#------------------- Clases -----------------------
    rule(:class_definition) { (str("abstract").maybe >> blank >>  str("class") >> blank >> simple_string >> blank >>
                            inherited_class.maybe.as(:INHERITED_CLASS) >> blank >> implements_class.maybe.as(:IMPLEMENTS_CLASS) >>
                            blank >> coment.as(:CLASS_COMENT).maybe >> blank >> str("{") >> blank >>
                            class_content.repeat.maybe >> blank >> str("}") ) >> blank }
    rule(:inherited_class)  { str("extends") >> blank >> simple_string }
    rule(:implements_class) { str("implements") >> blank >> simple_string >> blank }
    rule(:class_content)    { (vars_definition.as(:VARS) | methods.as(:METHODS) | coment) >> blank}
    rule(:vars_definition)  { (type_var_method.repeat.maybe >> blank >> str("var").maybe >> blank >> (var_assignment.as(:VA) |
                            simple_string.as(:SST)) >> blank >> str(";")) >> blank}
    rule(:type_var_method)  { (str("public") | str("private") | str("static") | str("protected") | str("const") |
                            str("var")) >> blank}
    rule(:methods)          { (abstract_method | method_definition) >> blank }
    rule(:method_definition){ (type_var_method.repeat.maybe >> blank >> define_function >> blank) }
    rule(:abstract_method)  { str("abstract") >> blank >> type_var_method.repeat.maybe >> blank >> str("function") >>
                            blank >> internal_function >> blank >> str(";") >> blank }
    rule(:class_instantiation){ str("new") >> blank >> variable >> blank >> str("(") >> blank >>
                            elements_array.maybe >> blank >> str(")") >> blank}
#--------------------------------------------------

#------------------- Coment -----------------------
    rule(:coment)           { ( block_coment | line_coment ) >> blank}
    rule(:line_coment)      { (str("//") | str("#")) >> (match('\n').absent? >> any).repeat(1).maybe >> blank }
    rule(:block_coment)     { (str('/*') >> (str('*/').absent? >> any).repeat >> str('*/')) }
#--------------------------------------------------

    rule(:namespace)        { ((str("namespace") | str("use")) >> blank >> ((str('\\') >> any) | (str(';').absent? >> any)).repeat >> str(';')) }
    rule(:only_sentence)    { (printers | var_assignment | return_sentence | continue) >> str(";") >> blank }
    rule(:printers)     { (str("echo") | str("print")) >> blank >> parameters >> blank}
    rule(:return_sentence)  { str("return") >> blank >> parameters.maybe >> blank }
    rule(:global_vars)      { (str("global") >> blank >> variable) >> blank }
    rule(:param_class)      { simple_string >> space? >> (var_assignment | simple_string) }
    rule(:continue)         { str("continue") >> blank >> match("[0-9]").repeat(1).maybe >> blank }
    rule(:var_assignment)   { left_part >> blank >> (string_op | assignment) >>
                            blank >> rigth_part >> coment.maybe >> blank}
    rule(:left_part)        { (internal_function | variable) }
    rule(:rigth_part)       { (dba_statement.as(:DBA_STATEMENT) | pdo_statement.as(:PDO_STATEMENT) | operation.as(:OPERATION) | var_array.as(:ARRAY) |
                            class_instantiation.as(:CLASS_INSTANTIATION) |
                            internal_function.as(:FUNCTIONS) | class_atributte.as(:CLASS_ATTR) | variable) >> blank }

    rule(:expresions)       { ((str("(").repeat.maybe >> blank >> (internal_function | array_one_position | param_class |
                            variable) >> blank >> str(")").repeat.maybe >> blank >> operators >>
                            blank).repeat.maybe >> blank >> str("(").repeat.maybe >> blank >> (internal_function | array_one_position |
                            param_class | variable) >> blank >> str(")").repeat) >> blank }
    rule(:variable)         { ( class_atributte | cadenas | array_one_position | internal_function |
                            simple_string | negative_decimal_numbers) >> blank }
    rule(:class_atributte)  { (array_one_position | simple_string) >> (str("->") >> (pdo_methods.as(:PDO_METHODS) | internal_function |
                            array_one_position | simple_string)).repeat(1) >> blank}
    rule(:simple_string)    { match("[a-zA-Z0-9/$:@!?&_]").repeat(1) >> blank}
    rule(:negative_decimal_numbers) { match("[0-9/.-]").repeat(1) >> blank}
    rule(:statements)       { any }#Puede ir cualquier cosa. match("[a-zA-Z0-9/$'']").repeat

    rule(:operators)        { (arithmetic | comparison | assignment | incrementing | decrementing | logical |
                            string_op | type_op) >> blank }
    rule(:arithmetic)       { (str("-") | str("+") | str("*") | str("/") | str("%") ) >> blank}
    rule(:comparison)       { (str("===") | str("==") | str("<=") | str(">=") | str("!==") | str("<>") | str("!=") |
    						str("<") | str(">")) >> blank}
    rule(:incrementing)     { str("++") >> blank }
    rule(:decrementing)     { str("--") >> blank }
    rule(:logical)          { (str("and") | str("or") | str("xor") | str("&&") | str("||")) >> blank }
    #| str("!")
    rule(:assignment)       { (str("=") | str("+=")) >> blank }
    rule(:string_op)        { (str(".=") | str(".")) >> blank }
    rule(:type_op)          { (str("instanceof")) >> blank }


    rule(:cadenas)          { ((str('"') >> ((str('\\') >> any) | (str('"').absent? >> any)).repeat >>
                                str('"')) | (str("'") >> ((str('\\') >> any) | (str("'").absent? >> any)).repeat >>
                                str("'"))) >> blank}

    rule(:internal_function){ ((dba_statement.as(:DBA_STATEMENT) | simple_string) >> blank >> str("(") >> blank >> parameters.maybe >>
                            blank >> str(")").maybe) >> blank }

    rule(:operation)        {with_paren.as(:with_paren) | without_paren.as(:without_paren)}

    rule(:with_paren)       { str("(") >> ((str("(").repeat.maybe >> blank >> (array_one_position | internal_function | class_atributte | cadenas |
                            variable) >> blank >> str(")").repeat.maybe >> blank >> operators >>
                            blank).repeat(1) >> blank >> str("(").repeat.maybe >> blank >> (array_one_position | internal_function |
                            class_atributte | cadenas | variable) >> str(")").repeat.maybe) >> blank }

    rule(:without_paren)    { ((array_one_position | internal_function | class_atributte | cadenas |
                            variable) >> blank >> operators >> blank).repeat(1) >> blank >> (with_paren | (array_one_position |
                            internal_function | class_atributte | cadenas | variable))}


    rule(:parameters)       {((operation.as(:OP_PARAM) | class_atributte | var_array.as(:ARRAY_PARAM) | internal_function.as(:INT_FUNC_PARAM) |
                            param_class.as(:PrmCL) | variable.as(:VAR_PARAM)) >> blank >> str(",") >> blank).repeat.maybe >>
                            blank >> (operation.as(:OP_PARAM) | class_atributte | var_array.as(:ARRAY_PARAM) | internal_function.as(:INT_FUNC_PARAM) |
                            param_class.as(:PrmCL) | variable) >> blank }


    rule(:exponentIndicator){ match("[eE]") }
    rule(:signedInteger)    { match("[+-]").maybe >> match("[0-9]").repeat(1) }
    rule(:decimalIntegerLiteral){ str("0") | nonZeroDigit >> decimalDigits.repeat }
    rule(:exponenPart)      { exponentIndicator >> signedInteger }
    rule(:octalIntegerLiteral){ (str("0") >> octalDigit.repeat(1)).as(:NUMERIC_LITERAL_OCT) }
    rule(:hexIntegerLiteral){ (str("0") >> match("[xX]") >> hexDigit.repeat(1)).as(:NUMERIC_LITERAL_HEX) }
    rule(:decimalLiteral)   { (decimalIntegerLiteral >> str(".") >> decimalDigits.repeat >> exponentPart.maybe).as(:NUMERIC_LITERAL_DEC) |
                                                            (str(".") >> decimalDigits >> exponentPart.maybe) |
                                                            (decimalIntegerLiteral >> exponentPart.maybe) }
    rule(:lineContinuation) { str("\\") >> ( match("\r\n") | match("\r") | match("\n")) }
    rule(:octalEscapeSequence){  }    # REVISAR (?:[1-7][0-7]{0,2}|[0-7]{2,3}) PÁG 244 ECMA
    rule(:hexEscapeSequence){ match("[x]") >> hexDigit.repeat(2,2) }
    rule(:uncodeEscapeSequence){ match("[u]") >> hexDigit.repeat(4,4) }
    rule(:singleEscapeCharacter){ match("[\'\"\\bfnrtv]")}
    rule(:nonEscapeCharacter){ match("[^\'\"\\bfnrtv0-9xu]") }
    rule(:characterEscapeSequence){ singleEscapeCharacter | nonEscapeCharacter }
    rule(:escapeSequence)   { characterEscapeSequence | octalEscapeSequence | hexEscapeSequence | unicodeEscapeSequence }
    rule(:doubleStringCharacter){ match("[^\"\\\n\r]").repeat(1) | ( str("\\") >> escapeSequence ) | lineContinuation }
    rule(:singleStringCharacter){ match("[^\'\\\n\r]").repeat(1) | ( str("\\") >> escapeSequence ) | lineContinuation }
    rule(:stringLiteral)    { (str("\"") >> doubleStringCharacter.repeat(1).maybe >> str("\"") | str("\'") >> singleStringCharacter.repeat(1).maybe >> str("\'")).as(:STRING_LITERAL) }




	root(:php_code)
end

class PhpTransformer < Parslet::Transform
    #los patterns de las rule deben contener todos los elementos (:elemento) del mismo nivel de jerarquía, de lo contrario no funcionará
    rule(:PDO_METHODS => simple(:x)) {
        resp = {}
        resp[:PDO_METHODS]= x.line_and_column      #con esto se puede obtener la ubicación del token en la cadena de entrada
        resp
    }
    rule(:DBA_STATEMENT => simple(:x)) {
        resp = {}
        resp[:DBA_STATEMENT]= x.line_and_column      #con esto se puede obtener la ubicación del token en la cadena de entrada
        resp
    }
    rule(:PDO_STATEMENT => simple(:x)) {
        resp = {}
        resp[:PDO_STATEMENT]= x.line_and_column      #con esto se puede obtener la ubicación del token en la cadena de entrada
        resp
    }
    rule(:POST => simple(:x)) {
        resp = {}
        resp[:POST]= x.line_and_column      #con esto se puede obtener la ubicación del token en la cadena de entrada
        resp
    }
    rule(:GET => simple(:x)) {
        resp = {}
        resp[:GET]= x.line_and_column      #con esto se puede obtener la ubicación del token en la cadena de entrada
        resp
    }
    #rule(:PDO_METHODS => simple(:x)) { x.line_and_column }

end

=begin
def parse(str)
  mini = PhpLexer.new

  mini.parse(str)
rescue Parslet::ParseFailed => failure
  puts failure.cause.ascii_tree
end

cadena = "if($pepe){
    $moni = 'no hace nada';
}elseif{
    $moni='tampoco hace nada';
}else{
    $moni = 'va de compras';
}"	# tiene problemas con la ñ
#if ($band){if ($band){$hola = 1}}else{if ($band){$hola = 1}}
string = "$fields[$field->name] = $field->value;
        $response->response = '[accepted]';"
archivo = File.read('/home/clifford/Documentos/archivos_prueba/scriptphp/Controller/controller.php')
#puts archivo.downcase
id = parse archivo.downcase
puts id
puts"*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
optimus = Transformer.new.apply(id)
pp optimus
=end
