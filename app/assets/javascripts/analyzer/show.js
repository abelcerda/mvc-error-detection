var App = App || {};

App.analyzer = (function() {
    
    return {
        showResults: function(){
          console.log("Hola estamos en un fichero de javascript");
        },
        
        init: function() {
            App.analyzer.showResults();
        }
    };
})();


$(function() {
    App.analyzer.init(); //Inicia el objeto
});