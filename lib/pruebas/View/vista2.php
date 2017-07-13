<!DOCTYPE html>
<html>
<head>
	<title>Menu</title>
	 <link href="../css/bootstrap-theme.min.css" rel="stylesheet">
</head>
<body>


<h1 class='alert alert-success'>

<?php
session_start();
if (!(isset($_SESSION['autenticado']))){
    header('Location:http://localhost/gramajo/Vistas/index.php');
}
echo "Usuario Logueado: ".$_SESSION['user'];
?>
</h1>
<h2>
<a href="http://localhost/gramajo/Vistas/logout.php"> logout </a>
</h2>
</body>
</html>