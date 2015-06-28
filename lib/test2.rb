require 'parslet'

class Phplexer < Parslet::Parser
    rule(:space)			{ match('\s').repeat(1) }
    rule(:space?)			{ space.maybe }
    rule(:eol)			    { match('\n').repeat(1) }
    rule(:eol?)			    { eol.maybe }
    rule(:blank)			{ space? | eol? }
    rule(:eof)              { any.absent? }
    
    rule(:php)              { php_tag(close: false).as(:PHP_OPEN) >> blank >> php_cont.as(:PHP_CONT) >> blank }

    rule(:php_cont)         { ( eof |coment | pdo_statement | str("?>").as(:PHP_CLOSE) ).repeat(1) >> blank }

    #rule(:php_cont)         { ( eof | (coment >> php_cont) | (pdo_statement >> php_cont) | str("?>").as(:PHP_CLOSE) | (php_code >> php_cont) ) >> blank }    
#----------------------------  Section for Php code  ------------------------------------------------
    rule(:php_code)         { ( control_structure | predefined_var | classes | function | operators | name_var | type_var ).repeat >> blank }
    rule(:control_struture) { (if_statement | while_statement | dowhile_statement | for_statement | foreach_statement | break_statement | continue_statement | switch_statement | declare_statement | return_statement | require_statement | include_statement | require_once_statement | include_once_statement | goto_statement) >> blank}

    
    rule(:if_statement)     { str("if") >> blank >> str("(") >> expresion >> str(")") >> blank >> str("{") >> blank >> statements >> blank >> str("}") >> blank }
    rule(:expresion)        { ( str("(").maybe >> variable >> operators.maybe >> variable.maybe >> str(")").maybe ) }
    rule(:variable)         { match("[a-zA-Z0-9 /$''.,]") >> blank}
    
    rule(:operators)        { (arithmetic | assignment | comparison | incrementing | decrementing | logical | string_op | type_op) >> blank }
    rule(:arithmetic)       { (str("-") | str("+") | str("*") | str("/") | str("%") ) >> blank}
    rule(:comparison)       { (str("==") | str("===") | str("!=") | str("<>") | str("!==") | str("<") | str(">") | str("<=") | str(">=")) >> blank}
    rule(:incrementing)     { str("++") >> blank }
    rule(:decrementing)     { str("--") >> blank }
    rule(:logical)          { (str("and") | str("or") | str("xor") | str("!") | str("&&") | str("||")) >> blank }
    rule(:assignment)       { (str("=")) >> blank }
    rule(:string_op)        { (str(".") | str(".=")) >> blank }
    rule(:type_op)          { (str("instanceof")) >> blank }
    
#----------------------------  End section Php code  ------------------------------------------------
#Section for PDO statement
    rule(:pdo_statement)    { (str("new PDO(").as(:NEW_PDO) | str("query(").as(:QUERY) | str("execute(").as(:EXECUTE) | str("fetch(").as(:FETCH) | str("fetchAll(").as(:FETCH_ALL) | str("fetchColumn(").as(:FETCH_COLUMN) | str("getAttribute(").as(:GET_ATTR) | str("getColumnMeta(").as(:GET_COL_META) | str("nextRowset(").as(:NEXT_ROW_SET) | str("rowCount(").as(:ROW_COUNT) | str("setAttribute").as(:SET_ATTR) | str("setFetchMode(").as(:SET_FETCH_MODE) | str("bindColumn(").as(:BIND_COL) | str("bindParam(").as(:BIND_PARAM) | str("bindValue(").as(:BIND_VALUE) | str("closeCursor(").as(:CLOSE_CURSOR) | str("columnCount(").as(:COLUMN_COUNT) | str("debugDumpParams(").as(:DEBUG_DUMP_PARAMS) | str("errorCode(").as(:ERROR_CODE) | str("errorInfo(").as(:ERROR_INFO)) >> blank }
#end section PDO
#Section for DBA statement
    rule(:dba_statement)    { ( srt("dba_open(").as(:DBA_OPEN) | srt("dba_exists(").as(:DBA_EXITS) | srt("dba_fetch(").as(:DBA_FETCH) | srt("dba_firstkey(").as(:DBA_FIRSTKEY) | srt("dba_handlers(").as(:DBA_HANDLERS) | srt("dba_insert(").as(:DBA_INSERT) | srt("dba_key_split(").as(:DBA_KEY_SPLIT) | srt("dba_list(").as(:DBA_LIST) | srt("dba_optimize(").as(:DBA_OPTIMIZE) | srt("dba_sync(").as(:DBA_SYNC) ) >> blank }
#end section
    rule(:php_code)         { any }
    rule(:coment)           { ( block_coment.as(:BLOCK_COMENT) | line_coment.as(:LINE_COMENT) ) >> blank}
    rule(:line_coment)      { (str("//") | str("#")) >> lc_end }
    rule(:lc_end)           { eol | ( any >> lc_end ) }
    rule(:block_coment)     { str('/*').as(:blc_open) >> bc_end }
    rule(:bc_end)           { (any >> bc_end) | str('*/').as(:blc_close) }
    
    root(:php)    
        
    def php_tag(opts={})
        close = opts[:close] || false

        parslet = str("?>") if close
        parslet = str('<?php')

        parslet
    end
end
    
def parse(str)
  mini = Phplexer.new
  
  mini.parse(str)
rescue Parslet::ParseFailed => failure
  puts failure.cause.ascii_tree
end

cadena = '<?php
/* Exercise PDOStatement::fetch styles */
//tu mama
/* ashdkajshdlaksj */
new PDO(
fetch(
?>
'	# tiene problemas con la ñ
puts cadena
id = parse cadena
puts id