<?php
require("clsMySQLServer.php");
require("clsBusqueda.php");

$porPagina = 2;
$paginar = true;
if(empty($_REQUEST['pagina'])){
	$_REQUEST['pagina'] = 0;
} 
	
$buscar = new MySQLServer('localhost','root','','prueba');
$buscar->debug=true;
$resultados = $buscar->Buscar($paginar,$_REQUEST['pagina'],$porPagina);


?>