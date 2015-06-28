require 'parslet'

class Mini < Parslet::Parser
   rule(:equal)              { match('=') >> blank}           
  rule(:cuote)              { match("'") | match('"') }  #eliminar el .as. No se pueden poner un .as para una conjunción OR ( | )
  rule(:letters)            { match['[a-z]'].repeat(1) }
    
    #Definiciones de los elementos de un script
  rule(:script_name)        { match('[a-z .%/\:_-]').repeat }
  rule(:script_attr_type)   { (str('src').as(:SRC) | str('type') | str('async')) >> blank }
  rule(:script_attribute)   { script_attr_type >> equal >> cuote >> script_name >> cuote >> blank }
  rule(:script_attribute?)  { script_attribute.maybe }
  rule(:script_tag_open)	{ (str('<script') >> blank >> script_attribute? >> str('>')) >> blank } # el .as(:SCRIPT_TAG_CLOSE) creo que no iría, el .as(:SCRIPT_EMBEDDED) ya sirve para detectar la posición del código
  rule(:script_tag_close)	{ str('</script>') >> blank }
  rule(:script_tag_section)	{ script_tag_open >> word?.as(:SCRIPT_EMBEDDED) >> script_tag_close }
  
    #Definiciones de los elementos de las etiquetas html
  #rule(:tag_open)           { (str('<') >> letters >> str('>')).as(:TAG_OPEN) >> blank }
  #rule(:tag_close)          { (str('</') >> letters >> str('>')).as(:TAG_CLOSE) >> blank }
  #rule(:tag)                { tag_open >> content >> tag_close }
  rule(:any_tag)            { (str('</') | str('<')) >> letters >> blank >> attr_list.repeat(1).as(:ATTR_LST).maybe >> str('>') >> blank}
    
  rule(:script_inline)      { (inlineEH >> equal >> attr_value)} 
  rule(:attr_NV)            { (letters ) }
  rule(:attr_list)          { (script_inline.as(:SCRIPT_INLINE) | attribute.as(:ATTR) | attr_NV.as(:ATNV)) >> blank }
  rule(:attr_value)         { cuote >> match('[a-z0-9 /.:,;{}()=_-]').repeat(1) >> cuote | 
                            match('[0-9,.]').repeat(1)}
  rule(:attribute)          { (match('[a-z0-9_-]').repeat >> equal >> attr_value.as(:VALUE))}  #el .as(:VALUE) sólo es para prueba e irrelevante.

  #Inline Event Handlers. Se deben escribir todos los manejadores de eventos capaces de aparecer como atributos
  rule(:inlineEH)           { str('onclick') | str('onmouseover') }
    
  rule(:space)			    { match('\s').repeat(1) }
  rule(:space?)			    { space.maybe }
  rule(:eol)			    { match('\n').repeat(1) }
  rule(:eol?)			    { eol.maybe }
  rule(:blank)			    { space? | eol? }

  rule(:html_open_tag)	    { str('<html>') >> blank }
  rule(:html_close_tag)	    { str('</html>') >> blank }
  rule(:doctype_tag)		{ str('<!doctype html') >> match("[a-z0-9 /'.,:_-]").repeat >> str('>') >> blank}
    # >> match("[a-z0-9 /'.,:_-]").repeat >> str('>') >> blank
  rule(:comment_end)        { str('-->') |
                              any >> comment_end }
  rule(:comment)            { str('<!--') >> comment_end  }

  rule(:word)			    { match('[^<]').repeat(1) }
  rule(:word?)			    { word.maybe }
    
  rule(:tag_section)        { tag_open >> content >> tag_close }

#  rule(:tag_section)	    { script_tag | tag } # scriptag | script_inline 
#  rule(:content)		{ esto me tira SystemStackError: stack level too deep
#				content >> script_tag >> content |
#				word?
#				} # scriptag | script_inline 

    
    #Definiciones de las reglas sintácticas fundamentales
  rule(:php_open)           {str('<?php').as(:PHP_OPEN) >> blank }
  rule(:php_close)          {str('?>').as(:PHP_CLOSE) >> blank }
  rule(:php_var)            {(str('$') >> letters).as(:PHP_VAR) }
  rule(:php_code_source)      {match("[a-z0-9A-Z /=';$,.]").repeat}
  rule(:space)      { match('\s').repeat(1) }
  rule(:space?)     { space.maybe }
  rule(:lparen)             { str('(') >> space? }
  rule(:rparen)             { str(')') >> space? }
  rule(:pdo_request)        { str('new pdo') >> lparen >> rparen }
  rule(:php_pdo_conection)  {php_var >> blank >> equal >> blank >> pdo_request.as(:PDO_REQUEST) }
    #>> equal >> (pdo_request | php_code_source) match("[a-zA-Z0-9'('')' /.:,;{}=_-]").repeat
  rule(:php_statement)      {(php_open >> (php_pdo_conection.as(:PDO_CONECTION) | php_code_source.as(:PHP_CODE)) >> php_close).as(:PHP_SECTION)}
  rule(:content)            { ( php_statement | comment | script_tag_section | any_tag | word ).repeat }
  rule(:html_content)       { html_open_tag >> content >> html_close_tag }

  rule(:webpage)		    { doctype_tag >> content >> eol?}#eol es cupla del objeto uploaded file

  root(:webpage)    
    
end

class Transformer < Parslet::Transform
  
=begin
  rule(:php_sec => { :left => subtree(:left), :right => subtree(:right) }) do
    (left + right)
  end

  rule(:and => { :left => subtree(:left), :right => subtree(:right) }) do
     res = []
     left.each do |l|
       right.each do |r|
         res << (l + r)
       end
     end
     res
  end
=end
end
=begin
cadena = "<!DOCTYPE html> 
<html>
<?php $tumama = new PDO() ?>
<head>
<script>
$(document).ready(function(){ //cuando el html fue cargado iniciar

    //aado la posibilidad de editar al presionar sobre edit

    // boton cancelar, uso live en lugar de bind para que tome cualquier boton
    // nuevo que pueda aparecer
    $('#cancel').live('click',function(){
        $('#block').hide();
        $('#popupbox').hide();
    })
})

NS={};
</script>
<script> 
</script>
</head>
<body>
     <?php $tumama = 'hola'; ?>
</body>
</html>
"	# tiene problemas con la ñ

puts cadena
id = parse cadena
puts id
id.each do |atom|
  line,col = atom[:SCRIPT_TAG_OPEN].line_and_column
  puts "Script Tag (#{atom[:SCRIPT_TAG_OPEN]}) detected at #{line}:#{col}!"
  line,col = atom[:SCRIPT_TAG_CLOSE].line_and_column
  puts "Script Tag (#{atom[:SCRIPT_TAG_CLOSE]} close at #{line}:#{col}!"
end
=end