require 'parslet'
require 'pp'
require 'yaml'

class PhpLexer < Parslet::Parser    
	rule(:space)                    { match('\s').repeat(1) }
	rule(:space?)                   { space.maybe }
	rule(:eol)                      { match('\n').repeat(1) }
	rule(:eol?)                     { eol.maybe }
	rule(:blank)                    { space? | eol? }
	rule(:eof)                      { any.absent? }
	rule(:space_aux)                { str(" ")}

	#rule(:script_tag_section)   { script_tag_open >> noscript.as(:CODE) >> script_tag_close }

 #   rule(:php_code)        { dowhile_statement.as(:DOWHILE) >> blank }
	rule(:analizer_file)            { (php_section.as(:PHP_SECTION) | html_section.as(:HTML_SECTION)).repeat(1) >> blank }

	rule(:html_section)             { ((str("<?php").absent? >> any).repeat(1)) >> blank }

	rule(:php_close)                { str("?>") >> blank }

	rule(:php_open)                 { str("<?php") >> blank }

	rule(:php_section)              { php_open >> blank >> php_code >> blank >> (php_close | eof).maybe >> blank }


	rule(:php_code)                 {(control_structure.as(:CONTROL_STRUCTURE) | pdo_statement | class_definition.as(:CLASS) | coment | define_function.as(:FUNCTION) | exceptions.as(:EXCEPTION) | interafaces.as(:INTERFACES) |one_line_statement.as(:ONE_LINE_STATEMENT)).repeat >> blank}


	rule(:content_ctrl_struct)      { ((php_open >> one_line_statement >> php_close) | (php_open >> control_structure) | html_section.as(:HTML_SECTION)) >> blank }

#       rule(:control_structure){(define_function.as(:function)) >> blank}

	rule(:control_structure)        { (while_statement.as(:WHILE) | if_statement.as(:IF) | dowhile_statement.as(:DO_WHILE) | foreach_statement.as(:FOREACH) | for_statement.as(:FOR)| switch_statement.as(:SWITCH)) >> blank}

#---------------- EXCEPTION -----------------------
	rule(:exceptions)               {(tryCatch.as(:TRY_CATCH) | thrown.as(:throw)) >> blank }
		
	rule(:tryCatch)                 {(str("try") >> blank >> str("{") >> blank >> ((php_close >> blank >> (tryContPhp | tryContPhpInc)) | (php_code.maybe >> blank >> str("}") >> blank >> (catch_php | catch_exc).repeat(1) >> blank >> finally_exc.maybe))) >> blank}
		
	rule(:tryContPhp)               {(content_ctrl_struct.repeat(1) >> blank >> ((php_open >> blank >> str("}") >> blank >> (catch_php | catch_exc)) | (php_open >> blank >> php_code.repeat >> blank >> str("}") >> blank >> catch_php))) >> blank }
	
	rule(:tryContPhpInc)            {(php_open >> blank >> php_code.repeat >>str("}") >> blank >> catch_exc >> blank >> finally_exc.maybe) >> blank } #caso en el que se abre el tag php y nunca mas se vuelve a cerrar

	rule(:catch_php)                {(str("catch") >> blank >> str("(") >> blank >> catch_conditions >> blank >> str(")") >> blank >> str("{") >> blank >> ((php_close >> blank >> (catchContPhp | catchContPhpInc)) | (php_code.maybe >> blank >> str("}") >> blank >> (finally_php | finally_exc).maybe))) >> blank }

	rule(:catchContPhp)             {(content_ctrl_struct.repeat(1) >> blank >> ((php_open >> blank >> str("}") >> blank >> (php_close | (finally_php))) | (php_open >> blank >> php_code.repeat >> blank >> str("}") >> blank >> (php_close |finally_php | finally_exc)))) >> blank  }

	rule(:catchContPhpInc)          {(php_open >> blank >> php_code.repeat >>str("}") >> blank >> finally_exc.maybe) >> blank  }

	rule(:finally_php)              {((str("finally") >> blank >> str("{")) >> blank >> (php_close >> content_ctrl_struct.repeat >> (php_open >> ((tryCatch_end) | (php_code.repeat >> blank >> str("}") >> blank >> php_close)))) ) >> blank }

	rule(:catch_exc)                {(str("catch") >> blank >> str("(") >> blank >> catch_conditions >> blank >> str(")") >> blank >> str("{") >> blank >> php_code.maybe >> blank >> str("}") >> blank) >> blank}

	rule(:finally_exc)              { (str("finally") >> blank >> str("{") >> blank >> php_code.maybe >> blank >>   str("}")) >> blank }

	rule(:catch_conditions)         { (simple_string >> blank >> simple_string) >> blank }
		
	rule(:tryCatch_end)             { (str("}") >> blank >> php_close) >> blank }

	rule(:thrown)                   { ((php_open >> blank >> str("throw") >> blank >> str("new") >> blank >> internal_function >> str(";").maybe >> blank >> php_close) | (str("throw") >> blank >> str("new") >> blank >> internal_function >> str(";").maybe)) >> blank}
#--------------------------------------------------

#-------------------- Functions -------------------
	rule(:function_statement)       { (str("parent::__construct") | simple_string) >> str("(") >> blank >> parameters.maybe >> blank >> str(")") >> blank >> str(";").maybe >> blank >> coment.maybe >> blank }
	rule(:define_function)          { str("function") >> blank >> (str("parent::__construct") | simple_string) >> blank >> str("(") >> blank >> parameters.maybe >> blank >> str(")").maybe >> blank >> coment.maybe >> blank >> str("{") >> blank >> ((php_close >> blank >> content_ctrl_struct.repeat >> blank >> ((php_open >> blank >> php_code >> blank >> str("}") >> blank >> php_close)| function_end)) | (php_code >> blank >> str("}"))) >> blank}

	rule(:function_end)             { (php_open >> blank >> str("}") >> blank >> php_close) >> blank }
	
	rule(:require_statement)        { ((str("require") | str("include") | str("require_once") | str("include_once")) >> blank >> str("(").maybe >> blank >> (cadenas | simple_string) >> blank >> str(")").maybe) >> blank }
	
	rule(:declare_statement)        { str("declare") >> str("(") >> (variable >> blank >>operators >> blank >> variable) >> str(")") >> blank >> str(";").maybe >> blank >> (var_assignment | control_structure ) >> blank >> str("}") >> blank }
	#Un parametro puede ser una operacion, por ejemplo: $i." ".$j... :/
#--------------------------------------------------



#------------------- Clases -----------------------
	rule(:class_definition)         { (str("abstract").maybe >> blank >> str("class") >> blank >> simple_string >> blank >> inherited_class.maybe >> blank >> implements_class.maybe >> blank >> coment.maybe >> blank >> str("{") >> blank >> class_content.repeat >> blank >> (str("}") | class_end_php_tag | class_end )) >> blank }

	rule(:inherited_class)          { str("extends") >> blank >> simple_string }
	
	rule(:implements_class)         { str("implements") >> blank >> simple_string >> blank }
	
	rule(:class_content)            { (vars_definition.as(:VARS) | methods.as(:METHODS) | coment) >> blank}
	
	rule(:vars_definition)          { (type_var_method.repeat.maybe >> blank >> str("var").maybe >> blank >> (var_assignment | ((simple_string >> blank >> str(",") >> blank).repeat(1) >> simple_string) | simple_string) >> blank >> str(";")) >> blank}

	rule(:type_var_method)          { (str("public") | str("private") | str("static") | str("protected") | str("const") | str("var")) >> blank}

	rule(:methods)                  { (abstract_method | method_definition) >> blank }
	
	rule(:method_definition)        { (type_var_method.repeat >> blank >> define_methods >> blank) }
#       rule(:alternative_cont) { (type_var_method.repeat.maybe >> blank >> define_methods >> blank) }
	rule(:define_methods)           { (str("function") >> blank >> (simple_string) >> blank >> str("(") >> blank >> parameters.maybe >> blank >> str(")").maybe >> blank >> coment.maybe >> blank >> str("{") >> blank >> ((php_close >> blank >> content_ctrl_struct.repeat.maybe >> blank >> ( function_end.as(:func_end) | (php_open >> blank >> php_code.repeat >> blank >> str("}") >> blank >> php_close).as(:end_phpClose) | (php_open >> blank >> php_code.repeat >> blank >> str("}") >> class_content.repeat).as(:end_without_phpClose))) | (php_code.maybe >> blank >> str("}")))) >> blank }

	rule(:abstract_method)          { str("abstract") >> blank >> type_var_method.repeat.maybe >> blank >> str("function") >> blank >> internal_function >> blank >> str(";") >> blank }

	rule(:class_instantiation)      {str("new") >> blank >> simple_string >> blank >> str("(") >> blank >> parameters.maybe >> blank >> str(")") >> blank}

	rule(:class_end_php_tag)        { (php_open >> blank >> str("}") >> blank >> php_close) >> blank }
	
	rule(:class_end)                { (str("}") >> blank >> php_close) >> blank }
#--------------------------------------------------

#-------------------- Switch ----------------------
	rule(:switch_statement)         {(swt_normal_syntax.as(:SWT_NORMAL_SYNTAX) | swt_alternative_syntax.as(:SWT_ALTERNATIVE_SYNTAX)) >> blank }
	
	rule(:swt_normal_syntax)        {str("switch") >> blank >> ((str("(") >> blank >> variable >> blank >> str(")"))) >> blank >> str("{") >> blank >> coment.maybe >> blank >>(switch_content | switch_case.as(:CASE_NORMAL)).repeat(1) >> blank >> coment.maybe >> blank >> switch_default.maybe >> blank >> str("}") >> coment.maybe >> blank}
	
	rule(:swt_alternative_syntax)   {(str("switch") >> blank >> (operation | (str("(") >> blank >> variable >> blank >> str(")"))) >> blank >> str(":") >> blank >> coment.maybe >> blank >> ((php_close >> blank >> switch_content.repeat(1)) | switch_case.repeat(1)) >> blank >> ((php_open >> str("endswitch;") >> blank >> php_close) | (str("endswitch;") >> blank >> php_close))) >> blank }
	
	rule(:switch_case)              {(str("case") >> blank >> variable >> blank >> str(":") >> blank >> php_code >> blank >> str("break;")) >> blank }
	
	rule(:switch_content)           {(php_open >> blank >> ( switch_case_tphp | switch_case | php_close).repeat(1)) >> blank }
	
	rule(:switch_case_tphp)         { (str("case") >> blank >> variable >> blank >> str(":") >> blank >> php_close >> content_ctrl_struct.repeat >> ((php_open >> blank >> php_code.repeat(1) >> blank >> str("break;").maybe >> blank) | switch_alternative_end_php)) >> blank}
	
	rule(:switch_alternative_end_php){ (php_open >> blank >> str("break;")) >> blank }
	
	rule(:switch_default)           { (str("default") >> blank >> str(":") >> blank >> php_code.maybe >> blank >> str("break;")) >> blank }
#--------------------------------------------------

#---------------------- For -----------------------
	rule(:for_statement)            { for_normal.as(:FOR_NORMAL) | for_alternative.as(:FOR_ALTERNATIVE)}

	rule(:for_normal)               {(str("for") >> blank >> str("(") >> blank >> for_conditions >> blank >> str(")") >> blank >> coment.maybe >> blank >> str("{") >> blank >> ((php_close >> blank >> content_ctrl_struct.repeat >> blank >> (php_open >> blank >> (for_normal_close | (one_line_statement >> blank >> for_normal_close)))) | (php_code.maybe >> blank >> str("}")))) >> blank }

	rule(:for_alternative)          { (str("for") >> blank >> str("(") >> for_conditions >> str(")") >> blank >> str(":") >> blank >> ((php_close >> blank >> content_ctrl_struct.repeat >> blank >> (php_open >> blank >> (for_alternative_close | (one_line_statement >> blank >> for_alternative_close)))) | (php_code.maybe >> blank >> str("endfor;")))) >> blank }
#    rule(:for_conditions)   { ((variable >> blank >> operators >> blank >> variable).maybe >> blank >> (str(";") |
#                           str(","))).repeat(1) >> blank >> increment_decrement.maybe } #Revisar el tema de las operaciones, por ejemplo: print f;
	rule(:increment_decrement)      { ((str("--") | str("++")) >> variable) | (variable >> (str("--") | str("++"))) >> blank}
	
	rule(:for_conditions)           { (parameters.maybe >> blank >> str(";")).repeat(2) >> blank >> increment_decrement.maybe }
	
	rule(:for_normal_close)         { (str("}") >> blank >> php_close) >> blank }
	
	rule(:for_alternative_close)    { (str("endfor;") >> blank >> php_close) >> blank }
#--------------------------------------------------

#------------------- Do While ---------------------
	rule(:dowhile_statement)        {(str("do") >> blank >> coment.maybe >> blank >> str("{") >> blank >> ((php_close >> blank >> ((content_ctrl_struct).repeat >> ((php_open >> blank >> dowhile_close) | (php_open >> blank >> one_line_statement >> blank >> dowhile_close)))) | (php_code >> blank >> str("}") >> blank >> str("while") >> blank >> ((str("(") >> blank >> variable >> blank >> str(")")) | operation) >> str(";"))) >> coment.maybe) >> blank}

	rule(:dowhile_close)            {(str("}") >> blank >> str("while") >> blank >> ((str("(") >> blank >> variable >> blank >> str(")")) | operation) >> blank >> str(";") >> blank >> php_close) >> blank}
#--------------------------------------------------

#------------------ Interfaces --------------------
	rule(:interafaces)              { (str("interfaces") >> blank >> simple_string >> blank >> str("{") >> blank >> interfaces_content.repeat(1) >> blank >> str("}")) >> blank}

	rule(:interfaces_content)       { str("public").maybe >> blank >> str("function") >> blank >> internal_function >> blank}
#--------------------------------------------------

#------------------- While ------------------------
	rule(:while_statement)          { while_normal_syntax.as(:WHILE_NORMAL) | while_alternative_syntax.as(:WHILE_ALTERNATIVE)}
	rule(:while_normal_syntax)      { str("while") >> blank >> expresions >> blank >> coment.maybe >> blank >> str("{") >> blank >> ((php_close >> blank >> (content_ctrl_struct).repeat >> blank >> (php_open >> blank >> ((one_line_statement >> blank >> while_normal_end) | while_normal_end))) | (php_code >> blank >> str("}"))) >> blank}

	rule(:while_alternative_syntax) { str("while") >> blank >> expresions >> blank >> coment.maybe >> blank >> str(":") >> blank >> ((php_close >> blank >> (content_ctrl_struct).repeat >> blank >> (php_open >> blank >> ((one_line_statement >> blank >> while_alternative_end) | while_alternative_end))) | (php_code >> blank >> str("endwhile;"))) >> blank } 

	rule(:while_normal_end)         { (str("}") >> blank >> (php_close | eof)) >> blank }
	
	rule(:while_alternative_end)    { (str("endwhile;") >> blank >> (php_close | eof)) >> blank }
#--------------------------------------------------

#------------------- if ---------------------------
	rule(:if_statement)             {( if_normal_form.as(:NORMAL_FORM) | if_short_form.as(:SHORT_FORM)) >> blank}
#if_one_line.as(:IF_ONE_LINE) |
	rule(:if_one_line)              {(str("if") >> blank >> operation >> blank >> str(")").repeat.maybe >> blank >> coment.as(:IF_COMENT).maybe >> blank >> str("{") )}
	
	rule(:else_one_line)            { str("else") >> blank >> only_sentence >> blank }

	rule(:if_normal_form)           {(str("if") >> blank >> operation >> blank >> str("{") >> blank >> ((php_close >> blank >> content_ctrl_struct.repeat >> blank >> php_open >> blank >> php_code.maybe >> blank >> ((str("}") >> blank >> (else_tag_php_normal | else_normal_form)) | (str("}") >> blank >> php_close) | (str("}")) | ((if_elseIf_normal | ((str("elseif") | str("else if")) >> blank >> operation >> blank >> str("{") >> blank >> php_code >> blank >> str("}") >> blank >> else_normal_form.maybe >> blank) | else_normal_form | else_one_line)).repeat.maybe)) | (php_code.maybe >> blank >> str("}") >> blank >> coment.maybe >> blank >> ((if_elseIf_normal) | ((str("elseif") | str("else if")) >> blank >> operation >> blank >> str("{") >> blank >> php_code >> blank >> str("}") >> blank >> else_normal_form.maybe >> blank) | (else_tag_php_normal | else_normal_form) | else_one_line).repeat.maybe))) >> blank}

	rule(:if_short_form)            {(str("if") >> blank >> operation >> blank >> str(":") >> blank >> ((php_close >> blank >> content_ctrl_struct.repeat >> blank >> php_open >> blank >> php_code.maybe >> blank >> (((else_tag_php_short | else_short_form)) | (str("endif;") >> blank >> php_close) | (str("endif;")) | ((if_elseIf_short | ((str("elseif") | str("else if")) >> blank >> operation >> blank >> str(":") >> blank >> php_code >> blank >> str("endif;") >> blank >> else_short_form.maybe >> blank) | else_short_form | else_one_line)).repeat.maybe)) | (php_code.maybe >> blank >> coment.maybe >> blank >> ( str("endif;") | (((if_elseIf_short) | ((str("elseif") | str("else if")) >> blank >> operation >> blank >> str(":") >> blank >> php_code >> blank >> str("endif;") >> blank >> else_short_form.maybe >> blank) | (else_tag_php_short | else_short_form) | else_one_line).repeat.maybe))))) >> blank}

	rule(:if_elseIf_normal)         {(str("elseif") | str("else if")) >> blank >> operation >> blank >> str("{") >> blank >> php_close >> blank >> (content_ctrl_struct).repeat >> blank >> ((php_open >> (one_line_statement | control_structure).repeat >> blank >> ((str("}") >> blank >> else_tag_php_normal) | (str("}") >> blank >> (php_close | eof)))) | ((php_open >> blank >> str("}") >> blank >> else_tag_php_normal) | if_normal_end)) >> blank }
	
	rule(:if_elseIf_short)          {(str("elseif") | str("else if")) >> blank >> operation >> blank >> str(":") >> blank >> php_close >> blank >> (content_ctrl_struct).repeat >> blank >> ((php_open >> (one_line_statement | control_structure).repeat >> blank >> ((else_tag_php_short) | (str("endif;") >> blank >> (php_close | eof)))) | ((php_open >> blank >> str("endif;") >> blank >> else_tag_php_short) | if_short_end)) >> blank}
	
	rule(:else_tag_php_short)       {(str("else") >> blank >> str(":") >> blank >> php_close >> blank >> (content_ctrl_struct).repeat >> blank >> (if_short_end | (php_open >> blank >> (one_line_statement | control_structure).repeat >> blank >> str("endif;") >> blank >> (php_close | eof))) >> blank)}

	rule(:else_tag_php_normal)      {(str("else") >> blank >> str("{") >> blank >> php_close >> blank >> (content_ctrl_struct).repeat >> blank >> (if_normal_end | (php_open >> blank >> (one_line_statement | control_structure).repeat >> blank >> str("}") >> blank >> (php_close | eof))) >> blank) }

	rule(:else_normal_form)         { str("else") >> blank >> coment.maybe >> blank >> str("{") >> blank >> ((php_close >> blank >> (content_ctrl_struct).repeat >> blank >> if_normal_end) | (php_code >> blank >> str("}"))) >> blank }

	rule(:else_short_form)          { (str("else") >> blank >> str(":") >> blank >> ((php_close >> blank >> (content_ctrl_struct).repeat >> blank) | php_code) >> blank >> (str("endif;") | if_short_end) >> blank >> coment.as(:COMENT_IF).maybe) >> blank }

	rule(:if_normal_end)            { (php_open >> blank >> str("}") >> blank >> (php_close | eof)) >> blank }
	
	rule(:if_short_end)             { (php_open >> blank >> str("endif;") >> blank >> (php_close | eof)) >> blank }

#--------------------------------------------------



	rule(:one_line_statement){ (namespace | var_assignment.as(:VAR_ASSIG) | global_vars.as(:G_VARS) |
							internal_function | require_statement | increment_decrement.as(:INC_DEC) | class_atributte |
							printers.as(:PRINT) | return_sentence.as(:RETURN) |
							continue.as(:CONTINUE) ) >> str(";") >> blank }
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
							str("bindparam") | str("bindvalue") | str("prepare") |
							str("closecursor") | str("columncount") |
							str("debugdumpparams") | str("errorcode") |
							str("errorinfo")) >> blank >> str("(") >>
							parameters >> blank >> str(")").maybe >> blank}
#-----------------------------------------------



#-------------------- ForEach ---------------------
	rule(:foreach_statement)        {(feach_normal_syntax.as(:FOREACH_NORMAL_SYNTAX) | feach_alternative_syntax.as(:FOREACH_ALTERNATIVE_SYNTAX)) >> blank}
	
	rule(:foreach_content)          { (var_array.as(:ARRAY) | variable) >> blank >> str("as") >> blank >> value_foreach >> blank }
	
	rule(:feach_alternative_syntax) { str("foreach") >> blank >> str("(") >> blank >> (var_array.as(:ARRAY) | variable) >> blank >> str("as") >> blank >> value_foreach >> blank >> str(")") >> blank >> str(":") >> blank >> ((php_close >> blank >> (content_ctrl_struct).repeat >> blank >> (php_open >> ((one_line_statement >> blank >> foreach_alternative_end) | foreach_alternative_end))) | (php_code >> blank >> str("endforeach;"))) >> blank }

	rule(:feach_normal_syntax)      { str("foreach") >> blank >> str("(") >> blank >> (var_array.as(:ARRAY) | variable) >> blank >> str("as") >> blank >> value_foreach >> blank >> str(")") >> blank >> str("{") >> blank >> ((php_close >> blank >> (content_ctrl_struct).repeat >> blank >> (php_open >> ((one_line_statement >> blank >> foreach_normal_end) | foreach_normal_end))) | (php_code >> blank >> str("}"))) >> blank  }

	rule(:var_array)                {(array_multiple_positions.as(:ARRAY_MULTIPLE_POSITIONS) | array_one_position.as(:ARRAY_ONE_POSITION)) >> blank }

	rule(:array_multiple_positions) { (str("array") >> blank >> str("(") >> blank >> (array_content | variable) >> blank >> str(")")) >> blank }
	rule(:array_one_position)       { ((str("$_post").as(:POST) | str("$_get").as(:GET) | str("array") | parent_string | simple_string) >> (str("[") >> blank >> (operation | internal_function | class_atributte | cadenas | variable).maybe >> blank >> str("]")).repeat(1)) >> blank }

	rule(:array_content)            { asociative_array.as(:ASOC_ARRAY) | elements_array.as(:SIMPLE_ARRAY) }
	
	rule(:elements_array)           { (((var_array | variable) >> blank >> str(",") >> ((blank >> coment >> blank) | blank)).repeat(1) >> blank >> (var_array | variable)) >> blank }
	
	rule(:value_foreach)            { (asociative_array | variable) }
	
	rule(:asociative_array)         { ((class_atributte | cadenas | simple_string) >> blank >> str("=>") >> blank >> (class_atributte | var_array | internal_function | operation | variable) >> blank >> str(",") >> ((blank >> coment >> blank) | blank)).repeat.maybe >> (((class_atributte | cadenas | simple_string) >> blank >> str("=>") >> blank >> (var_array | internal_function | operation | variable)) | (var_array | internal_function | operation | variable)) >> blank }

	rule(:foreach_normal_end)       {(str("}") >> blank >> (php_close | eof)) >> blank}
	
	rule(:foreach_alternative_end)  {(str("endforeach;") >> blank >> (php_close | eof)) >> blank}
#--------------------------------------------------

	rule(:increment_decrement)      { ((str("--") | str("++")) >> variable) | (variable >> (str("--") | str("++"))) >> blank}

#------------------- Coment -----------------------
	rule(:coment)                   { ( block_coment | line_coment ) >> blank}
	rule(:line_coment)              { (str("//") | str("#")) >> (match('\n').absent? >> any).repeat(1).maybe >> blank }
	rule(:block_coment)             { (str('/*') >> (str('*/').absent? >> any).repeat >> str('*/')) }
#--------------------------------------------------

	rule(:namespace)                { ((str("namespace") | str("use")) >> blank >> ((str('\\') >> any) | (str(';').absent? >> any)).repeat) >> blank }
	rule(:only_sentence)            { (printers | var_assignment | return_sentence | continue) >> str(";") >> blank }
	rule(:printers)                 { (str("echo") | str("print")) >> blank >> parameters >> blank}
	rule(:return_sentence)          { str("return") >> blank >> parameters.maybe >> blank }
	rule(:global_vars)              { (str("global") >> blank >> variable) >> blank }
	rule(:param_class)              { simple_string >> space? >> (var_assignment | simple_string) }
	rule(:continue)                 { str("continue") >> blank >> match("[0-9]").repeat(1).maybe >> blank }
	rule(:var_assignment)           { left_part >> blank >> (string_op | assignment) >> blank >> rigth_part >> coment.maybe >> blank}
	rule(:left_part)                {(internal_function | variable) }
	rule(:rigth_part)               {(dba_statement.as(:DBA_STATEMENT) | pdo_statement.as(:PDO_STATEMENT) | operation.as(:OPERATION) | var_array.as(:ARRAY) | class_instantiation.as(:CLASS_INSTANTIATION) | internal_function |  variable) >> blank }

	rule(:end_of_statement)         { (str("endif") | str("endwhile") | str("endforeach") | str("endswitch") | str("endfor")) >> blank }
	rule(:expresions)               {(((str("(").repeat.maybe >> blank >> (internal_function | array_one_position | param_class | variable) >> blank >> str(")").repeat.maybe >> blank >> operators >> blank).repeat.maybe >> blank >> str("(").repeat.maybe >> blank >> (internal_function | array_one_position | param_class | variable) >> blank >> str(")").repeat) | (((internal_function | array_one_position | param_class |variable) >> blank >> operators).repeat(1) >> blank >> (internal_function | array_one_position | param_class |variable))) >> blank }

	rule(:variable)                 { ( class_atributte | cadenas | array_one_position | internal_function | parent_string | simple_string | negative_decimal_numbers) >> blank }

	rule(:class_atributte)          { (array_one_position | simple_string) >> (str("->") >> (pdo_methods.as(:PDO_METHODS) | internal_function | array_one_position | simple_string)).repeat(1) >> blank}

	rule(:simple_string)            { match("[a-zA-Z0-9/$@!?&_]").repeat(1) >> blank}
	
	rule(:negative_decimal_numbers) { match("[0-9/.-]").repeat(1) >> blank}
	
	rule(:statements)               { any }#Puede ir cualquier cosa. match("[a-zA-Z0-9/$'']").repeat
	
	rule(:parent_string)            { (simple_string >> str("::")>> simple_string) >> blank }
	
	rule(:operators)                { (arithmetic | comparison | assignment | incrementing | decrementing | logical | string_op | type_op) >> blank }

	rule(:arithmetic)               { (str("-") | str("+") | str("*") | str("/") | str("%") ) >> blank}
	
	rule(:comparison)               { (str("===") | str("==") | str("<=") | str(">=") | str("!==") | str("<>") | str("!=") | str("<") | str(">")) >> blank}

	rule(:incrementing)             { str("++") >> blank }
	
	rule(:decrementing)             { str("--") >> blank }
	
	rule(:logical)                  { (str("and") | str("or") | str("xor") | str("&&") | str("||")) >> blank }
	#| str("!")
	rule(:assignment)               { (str("=") | str("+=")) >> blank }
	
	rule(:string_op)                { (str(".=") | str(".")) >> blank }
	
	rule(:type_op)                  { (str("instanceof")) >> blank }


	rule(:cadenas)                  { ((str('"') >> ((str('\\') >> any) | (str('"').absent? >> any)).repeat >> str('"')) | (str("'") >> ((str('\\') >> any) | (str("'").absent? >> any)).repeat >> str("'"))) >> blank}

	rule(:internal_function)        { ((str("parent::__construct") | dba_statement.as(:DBA_STATEMENT) | parent_string | simple_string) >> blank >> str("(") >> blank >> parameters.maybe >> blank >> str(")").maybe) >> blank }

	rule(:operation)                {(with_paren | without_paren | only_argument) >> blank}

	rule(:with_paren)               { str("(") >> ((str("(").repeat.maybe >> blank >> (array_one_position | internal_function | class_atributte | cadenas | variable) >> blank >> str(")").repeat.maybe >> blank >> operators >> blank).repeat(1) >> blank >> str("(").repeat.maybe >> blank >> (array_one_position | internal_function | class_atributte | cadenas | variable) >> str(")").repeat.maybe) >> blank }

	rule(:without_paren)            { ((array_one_position | internal_function | class_atributte | cadenas | variable) >> blank >> operators >> blank).repeat(1) >> blank >> (with_paren | (array_one_position | internal_function | class_atributte | cadenas | variable))}

	rule(:only_argument)            { (str("(") >> blank >> (array_one_position | internal_function | class_atributte | cadenas | variable) >> blank >> str(")")) >> blank }

	rule(:parameters)               {((operation | class_atributte | var_array.as(:ARRAY_PARAM) | internal_function.as(:INT_FUNC_PARAM) | param_class | variable) >> blank >> str(",") >> blank).repeat.maybe >> blank >> (operation | class_atributte | var_array.as(:ARRAY_PARAM) | internal_function | param_class.as(:PrmCL) | variable) >> blank }

	root(:analizer_file)
end

class PhpTransformer < Parslet::Transform
	$elementsToAnalizer = ["PDO_METHODS","PDO_STATEMENT","GET","POST","DBA_STATEMENT"]
	#los patterns de las rule deben contener todos los elementos (:elemento) del mismo nivel de jerarquía, de lo contrario no funcionará
	
	rule(:CONTROL_STRUCTURE => subtree(:x)) {
		x
	}
	rule(:CLASS_INSTANTIATION => subtree(:x)){
		x
	}
	#---------------- CASE -----------------
	rule(:SWITCH => subtree(:x)) {
		x
	}
	rule(:SWT_NORMAL_SYNTAX => subtree(:x)) {
		x
	}
	rule(:SWT_ALTERNATIVE_SYNTAX => subtree(:x)) {
		x
	}
	rule(:CASE_NORMAL => subtree(:x)) {
		x
	}
	#-------------- IF ---------------------
	rule(:IF => subtree(:x)) {
		x
	}
	rule(:IF_ONE_LINE => subtree(:x)) {
		x
	}
	rule(:NORMAL_FORM => subtree(:x)) {
		x
	}
	rule(:SHORT_FORM => subtree(:x)) {
		x
	}
	rule(:NORMAL_WAY_IF => subtree(:x)) {
		x
	}
	#Pendiente Resolver por que no entras por la llave :IF_OPERATIONS

	#--------------- WHILE -----------------
	rule(:WHILE => subtree(:x)) {
		x
	}
	rule(:WHILE_OPERATION => subtree(:x)) {
		x
	}
	rule(:WHILE_NORMAL => subtree(:x)) {
		x
	}
	rule(:WHILE_ALTERNATIVE => subtree(:x)) {
		x
	}

	#------------- Do While ---------------
	rule(:DO_WHILE => subtree(:x)) {
		x
	}
	rule(:DO_WHILE_COMENT => subtree(:x)) {
		x
	}
	rule(:DO_WHILE_OPERATION => subtree(:x)) {
		x
	}
	rule(:WHILE_ALTERNATIVE => subtree(:x)) {
		x
	}

	#----------- FOR ---------------------
	rule(:FOR => subtree(:x)) {
		x
	}
	rule(:FOR_NORMAL => subtree(:x)) {
		x
	}
	rule(:FOR_ALTERNATIVE => subtree(:x)) {
		x
	}

	#------------------- Clases -----------------------
	rule(:CLASS => subtree(:x)) {
		x
	}
	rule(:VARS => subtree(:x)) {
		if x.is_a?(Hash)
			x
		else
			''
		end
	}
	rule(:METHODS => subtree(:x)) {
		x
	}
	rule(:PrmCL => subtree(:x)) {
		if x.is_a?(Hash)
			x
		else
			''
		end
	}
	#----------------- FUNCTIONS ---------------------
	rule(:FUNCTION => subtree(:x)) {
		x
	}

	#----------------- Try Catch ---------------------
	rule(:EXCEPTION => subtree(:x)) {
		x
	}
	rule(:TRY_CATCH => subtree(:x)) {
		x
	}
	rule(:throw => subtree(:x)) {
		if x.is_a?(Hash)
			x
		else
			''
		end
	}

	#----------------- For each ---------------------
	rule(:FOREACH => subtree(:x)) {
		x
	}
	rule(:FOREACH_NORMAL_SYNTAX => subtree(:x)) {
		x
	}
	rule(:FOREACH_ALTERNATIVE_SYNTAX => subtree(:x)) {
		x
	}

	rule(:ARRAY => subtree(:x)) {
		x
	}
	rule(:ARRAY_MULTIPLE_POSITIONS => subtree(:x)) {
		x
	}

	rule(:ARRAY_ONE_POSITION => subtree(:x)) {
		if x.is_a?(Hash)
			x
		else
			''
		end
	}

	rule(:ASOC_ARRAY => subtree(:x)) {
		x
	}
	rule(:SIMPLE_ARRAY => subtree(:x)) {
		x
	} 
	rule(:ONE_LINE_STATEMENT => subtree(:x)) {
		if x.is_a?(Hash) || x.is_a?(Array)
			x
		else
			''
		end
	}
	rule(:VAR_ASSIG => subtree(:x)) {
		x
	}
	
	
	#rule(:CLASS_ATTR => subtree(:x)){
	#    x
	#}
=begin
	rule(:VAR_ASSIG => subtree(:x)) {
		x

		if x.is_a?(Hash) || x.is_a?(Array)
			x
		else
			''#Buscar la forma de eliminar este elemento del array.
		end
	}
=end

	rule(:ARRAY_PARAM => subtree(:x)) {
		if x.is_a?(Hash)
			x
		else
			''
		end
	}
	rule(:ARRAY => subtree(:x)) {
		x
	}

	rule(:PRINT => subtree(:x)) {
		if x.is_a?(Hash)
			x
		else
			''
		end
	}
	rule(:RETURN => subtree(:x)) {
		if x.is_a?(Hash)
			x
		else
			''
		end
	}
	rule(:OPERATION => subtree(:x)){
		if x.is_a?(Hash)
			x
		else
			''
		end
	}
	rule(:INT_FUNC_PARAM => subtree(:x)){
		if x.is_a?(Hash)
			x
		else
			''
		end
	}
	rule(:G_VARS => subtree(:x)){
		x
	}

	rule(:PDO_METHODS => simple(:x)) {
		resp = {}
		resp[:PDO_METHODS] = x.line_and_column
		resp
	}
	rule(:DBA_STATEMENT => simple(:x)) {
		resp = {}
		resp[:DBA_STATEMENT]= x.line_and_column      
		resp
	}
	rule(:PDO_STATEMENT => simple(:x)) {
		resp = {}
		resp[:PDO_STATEMENT]= x.line_and_column      
		resp
	}
	rule(:POST => simple(:x)) {
		resp = {}
		#puts "Aqui esta el PP *****************************************"     
		#puts YAML::dump(x.str)
		#puts x.str
		resp[:POST]= x.line_and_column      
		resp
	}
	
	rule(:GET => simple(:x)) {
		resp = {}
		resp[:GET]= x.line_and_column      
		resp
	}

end


def parse(str)
  mini = PhpLexer.new

  mini.parse(str)
rescue Parslet::ParseFailed => failure
  puts failure.cause.ascii_tree
end
=begin
cadena = "if($pepe){
	$moni = 'no hace nada';
}elseif{
	$moni='tampoco hace nada';
}else{
	$moni = 'va de compras';
}"  # tiene problemas con la ñ
#if ($band){if ($band){$hola = 1}}else{if ($band){$hola = 1}}
string = "$fields[$field->name] = $field->value;
		$response->response = '[accepted]';"
#archivo = File.read('/home/clifford/Documentos/archivos_prueba/scriptphp/Controller/controller.php')
archivo = File.read('/home/clifford/Documentos/archivos_prueba/DirPrueba/scriptB.php')
#puts archivo.downcase
id = parse archivo.downcase
puts id
puts"*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
optimus = PhpTransformer.new.apply(id)
pp optimus
=end