require 'parslet'

class PHPtoMVCTransformer < Parslet::Transform
	
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
	rule(:CASE_WITHOUT_CONTENT => subtree(:x)){
		if x.is_a?(Hash)
			x
		else
			''
		end
	}
	#-------------- IF ---------------------
	rule(:IF => subtree(:x)) {
		x
	}
	rule(:IF_SHORT_CONTENT => subtree(:x)) {
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
	rule(:FOREACH_ONE_SENTENCE => subtree(:x)){
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
	
	rule(:ternary_logic => subtree(:x)){
		#x
	}

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
	rule(:INC_DEC => subtree(:x)){
		x
	}
	rule(:CONTINUE => subtree(:x)){
		if x.is_a?(Hash)
			x
		else
			''
		end
	}
	rule(:BREAK => subtree(:x)){
		if x.is_a?(Hash)
			x
		else
			''
		end
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
		resp[:POST]= x.line_and_column      
		resp
	}
	
	rule(:GET => simple(:x)) {
		resp = {}
		resp[:GET]= x.line_and_column      
		resp
	}

	rule(:REQUEST => simple(:x)) {
		resp = {}
		resp[:REQUEST]= x.line_and_column      
		resp
	}

end
