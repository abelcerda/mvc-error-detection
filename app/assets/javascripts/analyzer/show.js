var App = App || {};

App.analyzer = (function() {
    
    return {
        checkFileInput: function(){
        		$("#analyzer_scripts").change(function(){
        			if($("#analyzer_scripts").get(0).files.length == 0){
			          	$("#btnAnalyzer").prop('disabled',true);
			          	$("#contMsgEmpty").show()
			          	$("#msgInputEmpty").text("No se han ingresado archivos para analizar");
			        }else{
			        	$("#btnAnalyzer").prop('disabled',false);
			        	$("#contMsgEmpty").hide()
			        }	
        		})
          
        },

        disabledBtn: function(){
        	if($("#analyzer_scripts").get(0).files.length == 0){
	          	$("#btnAnalyzer").prop('disabled',true);
	        }
        },
        
        init: function() {
        	//App.analyzer.disabledBtn();
            //App.analyzer.checkFileInput();
        }
    };
})();


$(function() {
    App.analyzer.init(); //Inicia el objeto
});