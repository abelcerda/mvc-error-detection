require 'parslet'

class Mini < Parslet::Parser
  rule(:equal)              { match('=').as(:EQUAL) >> blank}           #eliminar el .as
  rule(:cuote)              { ( match("'") | match('"') ).as(:CUOTE) }  #eliminar el .as
  rule(:letters)            { match['[a-z ]'].repeat }
  #rule(:tag_names)          { str('head') }    #necesario?
    
  rule(:script_name)        { match('[a-z .%/\:_-]').repeat }
  rule(:script_attr_type)   { (str('src') | str('type') | str('async')) >> blank }
  rule(:script_attribute)   { script_attr_type >> equal >> cuote >> script_name >> cuote >> blank }
  rule(:script_attribute?)  { script_attribute.maybe }
  rule(:script_tag_open)	{ (str('<script') >> blank >> script_attribute? >> str('>')).as(:SCRIPT_TAG_OPEN) >> blank }
  rule(:script_tag_close)	{ str('</script>').as(:SCRIPT_TAG_CLOSE) >> blank }
  rule(:script_tag_section)	{ script_tag_open >> word?.as(:SCRIPT_EMBEDDED) >> script_tag_close }
  
  rule(:tag_open)           { (str('<') >> letters >> str('>')).as(:TAG_OPEN) >> blank }
  rule(:tag_close)          { (str('</') >> letters >> str('>')).as(:TAG_CLOSE) >> blank }
  rule(:tag)                { tag_open >> content >> tag_close }
  #rule(:allowed_attr)       { match('[a-z ".]') }
  #rule(:attribute)          { (letters >> equal >> ) }
  
  rule(:space)			    { match('\s').repeat(1) }
  rule(:space?)			    { space.maybe }
  rule(:eol)			    { match('\n').repeat(1) }
  rule(:eol?)			    { eol.maybe }
  rule(:blank)			    { space? | eol? }

  rule(:html_open_tag)	    { str('<html>') >> blank }
  rule(:html_close_tag)	    { str('</html>') >> blank }
  rule(:doctype_tag)		{ str('<!DOCTYPE html') >> match('[a-z0-9 /".,:_-]').repeat >> str('>') >> blank }
    
  rule(:comment)            { str('<!--') >> match['[^>-]'].repeat >> str('-->') }

  rule(:word)			    { match('[^<]').repeat(1) }
  rule(:word?)			    { word.maybe }
  
  rule(:tag_section)        { tag_open >> content >> tag_close }
    
  rule(:php_open)           {str('<?php').as(:PHP_OPEN) >> blank }
  rule(:php_close)          {str('?>').as(:PHP_CLOSE) >> blank }
  rule(:php_var)            {str('$') >> letters.as(:PHP_VAR) }
  rule(:php_code_source)      {match('[a-z0-9A-Z /";$,.]').repeat.as(:PHP_CODE)}
  rule(:pdo_request)        { str('new PDO') >> str('(') >> str(')')}
  rule(:php_pdo_conection)  {php_var >> equal >> pdo_request.as(:PDO_CONECTION) | php_code_source }
  rule(:php_statement)      {php_open >> php_pdo_conection | php_code_source >> php_close}
    
  rule(:content)            { ( php_statement | tag_section | script_tag_section | word ).repeat.as(:CONTENIDO) }
  rule(:html_content)       { html_open_tag >> content >> html_close_tag }

  rule(:webpage)		    { doctype_tag >> html_content }

  root(:webpage)
end

def parse(str)
  mini = Mini.new
  
  mini.parse(str)
rescue Parslet::ParseFailed => failure
  puts failure.cause.ascii_tree
end

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
     <?php $tumama = 'hola'; 
        echo $tuvieja;
     ?>
</body>
</html>
"	# tiene problemas con la ñ
puts cadena
id = parse cadena
puts id

