require 'parslet'

class Mini < Parslet::Parser
    rule(:space)			{ match('\s').repeat(1) }
    rule(:space?)			{ space.maybe }
    rule(:eol)			    { match('\n').repeat(1) }
    rule(:eol?)			    { eol.maybe }
    rule(:blank)			{ space? | eol? }
    rule(:eof)              { any.absent? }
    
    #Integrar el tema de las variables.
    rule(:php_code)         { ( control_structure ) >> blank }
    rule(:control_structure) { (class_definition.as(:CLASS) | while_statement.as(:WHILE) | if_statement.as(:IF) | dowhile_statement.as(:DO_WHILE) | foreach_statement.as(:FOREACH) | for_statement.as(:FOR) | switch_statement.as(:SWITCH) | define_function.as(:FUNCTION) | return_print.as(:RETURN_PRINT) | var_assignment | coment).repeat(1) >> blank}
    #rule(:control_structure) { var_assignment.as(:CLASS) >> blank }
    #------------------- if ---------------------------
    rule(:if_statement)     { if_short_form.as(:SHORT_FORM) | if_normal_form.as(:NORMAL_FORM) }
    rule(:if_normal_form)    { (str("if") >> blank >> operation.as(:OPERATIONS) >> coment.as(:COMENT_IF).maybe >> blank  >> str("{") >> blank >> (var_assignment | control_structure ).repeat >> blank >> str("}") >> coment.as(:COMENT_IF).maybe >> blank >> ((str("else") >> blank >> str("{") >> blank >> (var_assignment | control_structure ).repeat >> str("}") >> coment.as(:COMENT_IF).maybe)| ((str("elseif") | str("else if")) >> blank >> operation.as(:OPERATION_ELSE) >> blank >> str("{") >> blank >> (var_assignment | control_structure ).repeat  >> blank >> str("}") >> blank >> coment.as(:COMENT_IF).maybe >> blank >> else_normal_form >> blank)).maybe)  >> blank }

    rule(:if_short_form)    { (str("if") >> blank >> operation.as(:OPERATIONS) >> blank >> str(":") >> blank >> (var_assignment | control_structure ).repeat >> blank >> ((str("endif;") >> blank) | (str("else") >> blank >> str(":") >> blank >> (var_assignment | control_structure ).repeat >> blank >> str("endif;") >> blank >> coment.as(:COMENT_IF).maybe >> blank) | ((str("elseif") | str("else if")) >> blank >> operation.as(:OPERATION_ELSE) >> blank >> str(":") >> blank >> (var_assignment | control_structure ).repeat  >> blank >> ((str("endif;") >> blank >> coment.as(:COMENT_IF).maybe) | else_short_form) >> blank)).maybe)  >> blank }

    rule(:else_normal_form)  { (str("else") >> blank >> str("{") >> blank >> (var_assignment | control_structure ).repeat >> blank >> str("}") >> blank >> coment.as(:COMENT_IF).maybe) >> blank }
    rule(:else_short_form)  { (str("else") >> blank >> str(":") >> blank >> (var_assignment | control_structure ).repeat >> blank >> str("endif;") >> blank >> coment.as(:COMENT_IF).maybe) >> blank }
    #--------------------------------------------------

    #-------------------- Functions -------------------
    rule(:function_statement){ variable >> str("(") >> blank >> ((parameters >> str(",") >> blank).repeat | variable) >> blank >> str(")") >> str(";").maybe >> blank >> coment.as(:COMENT_FUNCTION) }
    rule(:define_function)  { str("function") >> blank >> variable >> blank >> str("(") >> blank >> array_content.maybe >> blank >> str(")") >> blank >> str("{") >> blank >> (var_assignment | control_structure ).repeat >> blank >> str("}") >> blank >> coment.as(:COMENT_FUNCTION).maybe }
    rule(:require_statement){ (str("require") | str("include") | str("require_once") | str("include_once")) >> blank >> str("(").maybe >> blank >> variable >> blank >> str(")").maybe >> str(";").maybe >> blank }
    rule(:declare_statement){ str("declare") >> str("(") >> (variable >> blank >>operators >> blank >> variable) >> str(")") >> blank >> str(";").maybe >> blank >> (var_assignment | control_structure ) >> blank >> str("}") >> blank }
    #--------------------------------------------------

    #---------------------- For -----------------------
    rule(:for_statement)    { for_alternative.as(:FOR_ALTERNATIVE) | for_normal.as(:FOR_NORMAL) }
    rule(:for_normal)       { (str("for") >> blank >> str("(") >> for_conditions >> str(")") >> blank >> str("{") >> blank >> (var_assignment | control_structure).repeat >> blank >> str("}") >> coment.as(:COMENT_FOR).maybe) >> blank}
    rule(:for_alternative)  { (str("for") >> blank >> str("(") >> for_conditions >> str(")") >> blank >> str(":") >> blank >> (var_assignment | control_structure).repeat >> blank >> str("endwhile") >> coment.as(:COMENT_FOR).maybe) >> blank }
    rule(:for_conditions)   { ((variable >> operators >> variable).maybe >> (str(";") | str(","))).repeat(1) >> increment_decrement.maybe } #Revisar el tema de las operaciones, por ejemplo: print f;
    rule(:increment_decrement)       { ((str("--") | str("++")) >> variable) | (variable >> (str("--") | str("++"))) }
    #--------------------------------------------------
    
    #-------------------- Switch ----------------------
    rule(:switch_statement) { (swt_normal_syntax.as(:SWT_NORMAL_SYNTAX) | swt_alternative_syntax.as(:SWT_ALTERNATIVE_SYNTAX)) >> blank }
    rule(:swt_normal_syntax){ str("switch") >> blank >> (operation | str("(") >> blank >> variable >> blank >> str(")")) >> blank >> str("{") >> blank >> coment.as(:COMENT_SWITCH).maybe >> blank >> switch_case >> blank >> str("}") >> coment.as(:COMENT_SWITCH).maybe}
    rule(:swt_alternative_syntax){ str("switch") >> blank >> (operation | str("(") >> blank >> variable >> blank >> str(")")) >> blank >> str(":") >> blank >> coment.as(:COMENT_SWITCH).maybe >> blank >> switch_case >> blank >> str("endswitch;") >> coment.as(:COMENT_SWITCH).maybe }
    rule(:switch_case)      {(str("case") >> blank >> variable >> blank >> str(":") >> blank >> (var_assignment | control_structure) >> blank >> str("break;").maybe >> blank).repeat }
    #--------------------------------------------------
    
    #-------------------- ForEach ---------------------
    rule(:foreach_statement){ feach_normal_syntax.as(:FOREACH_NORMAL_SYNTAX) | feach_alternative_syntax.as(:FOREACH_ALTERNATIVE_SYNTAX) }
    rule(:feach_normal_syntax){ str("foreach") >> blank >> str("(") >> blank >> (var_array.as(:ARRAY) | variable) >> blank >> str("as") >> blank >> value_foreach >> blank >> str(")") >> blank >> str("{") >> blank >> ( var_assignment | control_structure ) >> blank >> str("}") >> coment.as(:COMENT_FOREACH).maybe >> blank }
    rule(:feach_alternative_syntax){ str("foreach") >> blank >> str("(") >> blank >> (var_array.as(:ARRAY) | variable) >> blank >> str("as") >> blank >> value_foreach >> blank >> str(")") >> blank >> str(":") >> blank >> ( var_assignment | control_structure ) >> blank >> str("endforeach;") >> coment.as(:COMENT_FOREACH).maybe >> blank }
    rule(:var_array)        { (array_multiple_positions.as(:ARRAY_MULTIPLE_POSITIONS) | array_one_position.as(:ARRAY_ONE_POSITION)) >> blank }
    rule(:array_multiple_positions){ (str("array") >> str("(") >> blank >> (array_content | variable) >> blank >> str(")")) >> blank }
    rule(:array_one_position){ (str("array") >> str("[") >> blank >> variable >> blank >> str("]")) >> blank }
    rule(:array_content)    { asociative_array | elements_array }
    rule(:elements_array)   { ((( var_array | variable) >> blank >> str(",") >> blank).repeat.maybe >> (var_array |  variable)) }
    rule(:value_foreach)    { (asociative_array | variable) }
    rule(:asociative_array) { ((variable >> blank >> str("=>") >> blank >> variable >> blank) >> str(",") >> blank).repeat.maybe >> (variable >> blank >> str("=>") >> blank >> variable) >> blank }
    
    #------------------- Do While ---------------------
    rule(:dowhile_statement){(str("do") >> blank >> str("{") >> blank >> (var_assignment | control_structure ).repeat >>  blank >> str("}") >> blank >> str("while") >> blank >> ((str("(") >> blank >> variable >> blank >> str(")")) | operation.as(:DO_WHILE_OPERATION)) >> str(";")) >> coment.as(:COMENT_DOWHILE).maybe >> blank}
    #--------------------------------------------------
    
    #------------------- While ------------------------
    rule(:while_statement)  { while_alternative_syntax.as(:WHILE_ALTERNATIVE) | while_normal_syntax.as(:WHILE_NORMAL) }
    rule(:while_normal_syntax)  { str("while") >> blank >> operation.as(:WHILE_OPERATION) >> blank >> str("{") >> (var_assignment | control_structure ).repeat >> str("}") >> coment.as(:COMENT_WHILE).maybe >>blank}
    rule(:while_alternative_syntax) { str("while") >> blank >> operation.as(:WHILE_OPERATION) >> blank >> str(":") >> (var_assignment | control_structure ).repeat >> str("endwhile") >> coment.as(:COMENT_WHILE).maybe >> blank } 
    #--------------------------------------------------
    
    #------------------- Clases -----------------------
    rule(:class_definition) { (str("class") >> blank >> variable >> blank >> str("{") >> blank >> class_content.repeat.maybe >> blank >> str("}") >> coment.as(:COMENT_CLASS).maybe) >> blank }
    rule(:class_content)    { vars_definition.as(:VARS) | method_difinition.as(:METHODS)}
    rule(:vars_definition)  { (str("public") | str("private")) >> blank >> variable >> blank >> str(";") >> blank }
    rule(:method_difinition){ (str("public") | str("private")).maybe >> blank >> define_function >> blank}
    rule(:class_instantiation){ str("new") >> blank >> variable >> blank >> str("(") >> blank >> elements_array.maybe >> blank >> str(")") >> blank }
    #--------------------------------------------------

    #------------------- Coment -----------------------
    rule(:coment)           { ( block_coment.as(:BLOCK_COMENT) | line_coment.as(:LINE_COMENT) ) >> blank}
    rule(:line_coment)      { (str("//") | str("#")) >> lc_end }
    rule(:lc_end)           { eol | ( any >> lc_end ) }
    rule(:block_coment)     { str('/*').as(:blc_open) >> bc_end }
    rule(:bc_end)           { str('*/').as(:blc_close) | (any >> bc_end)}
    #--------------------------------------------------

    rule(:return_print)     { (str("echo") | str("return")) >> blank >> (operation | variable | function_statement) >> str(";").maybe }
    rule(:var_assignment)   { left_part >> assignment >> rigth_part >> str(";").maybe >> coment.maybe >> blank}
    rule(:left_part)        { variable }
    rule(:rigth_part)       { var_array.as(:ARRAY) | class_instantiation.as(:CLASS_INSTANTIATION) | operation.as(:OPERATION) | variable }
    rule(:operation)        { str("(").repeat.maybe >> (variable >> blank >> str(")").repeat.maybe >> blank >> operators >> blank).repeat.maybe >> variable >> str(")").repeat.maybe >>blank}
    rule(:expresion)        { str("(").repeat >> blank >> variable >> blank >> ( (str(")").repeat(1) >> blank >> (str("{") | str(":") | str(";"))) | (str(")").repeat >> expresion) | operators.maybe >> expresion ) >> blank }
    rule(:variable)         { ( class_atributte.as(:CLASS_ATRIBUTTE) | simple_string ) >> blank }
    rule(:class_atributte)  { str("$this->") >> simple_string >> blank }
    rule(:simple_string)    { match("[a-zA-Z0-9/$'']").repeat >> blank }
    rule(:statements)       { any }#Puede ir cualquier cosa. match("[a-zA-Z0-9/$'']").repeat

    rule(:operators)        { (arithmetic | comparison | assignment | incrementing | decrementing | logical | string_op | type_op) >> blank }
    rule(:arithmetic)       { (str("-") | str("+") | str("*") | str("/") | str("%") ) >> blank}
    rule(:comparison)       { (str("==") | str("===") | str("<=") | str(">=") | str("!=") | str("<>") | str("!==") | str("<") | str(">")) >> blank}
    rule(:incrementing)     { str("++") >> blank }
    rule(:decrementing)     { str("--") >> blank }
    rule(:logical)          { (str("and") | str("or") | str("xor") | str("!") | str("&&") | str("||")) >> blank }
    rule(:assignment)       { (str("=")) >> blank }
    rule(:string_op)        { (str(".") | str(".=")) >> blank }
    rule(:type_op)          { (str("instanceof")) >> blank }
    
    root(:php_code)
    
        
end

def parse(str)
  mini = Mini.new
  
  mini.parse(str)
rescue Parslet::ParseFailed => failure
  puts failure.cause.ascii_tree
end


cadena = "if ($band){ //Esto es un comentario
if ($band){$hola = 6}}
else{
if ($band){
$hola = 1}
}
$auto = new Autos();
// Esto es un comentario
// Esta es la segunda linea de un comentario
$vector = array(3, 5, array(6,7,8)) // array multidimensional
/* Esto es una funcion que deuvleve un libro
a partir de varios parametros */
function getBook(id,$3,$n,$hola){
    if ($band){
        $hola = 1;
    }
    for($i=0,$b=3;$i<=9;$i==$b,$i++){ 
        $hola = 1; 
    }
    $conan = ((($gular + $js) + $N) * $f)
    $vector = array(8,9,0)
    $oneElement = array[4] //Esto es la asignacion de un valor de un arrya a una variable
}
class Autos {
    private marca;
    private modelo;

    public function varAuto(){
        $datos = array($this->marca,$this->modelo,fiat)
        return $datos;
    }
}
while($band):if ($band2){$hola = 1}endwhile
do {//Hola mundo
$hola = 1
}while($band);
for($i=0,$b=3;$i<=9;$i==$b,$i++){ 
$hola = 1 
}
foreach($array as $element): 
  $peli = corta
endforeach; 
foreach (array($r => 2, $t => 2) as $k => $v) {
   if ($band){//Comentario 2
        $hola = 3 + 5
   }else{//comentario 3
        $pepe = 25
   }
}
switch ($i % 12) { 
    case f:
        $pepe = hola
        break;
    case g:
        if($bandera){
            if ($band){
                $hola = 3
            }
        }else{
            $tuvieja = 3
        }
        for($i=0,$b=3;$i<=9;$i==$b,$i++){ 
            $hola = 1 
        }
        break;
}
switch ($year % 12) :
    case  0: 
        return $pepe
    case  1: 
        $year = anio
        break;
endswitch;"	# tiene problemas con la ñ
#if ($band){if ($band){$hola = 1}}else{if ($band){$hola = 1}}
string = "$auto = new Autos(9,bmw);"
puts cadena
id = parse cadena
puts id
