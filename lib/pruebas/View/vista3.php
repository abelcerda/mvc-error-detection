

<!DOCTYPE html>
<!-- saved from url=(0039)http://getbootstrap.com/examples/theme/ -->
<html lang="es">
    <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <meta name="description" content="">
            <meta name="author" content="">
            <link rel="shortcut icon" href="http://getbootstrap.com/assets/ico/favicon.ico">
            
            <!-- Bootstrap core JavaScript
            ================================================== -->
            <!-- Placed at the end of the document so the pages load faster -->
            <script src="../js/jquery.js"></script>
            <script src="../js/bootstrap.min.js"></script>
  
          <!--   <link type="text/javascript" href="js/jquery.js">  -->
      
            <title> Bootstrap</title>

            <!-- Bootstrap core CSS -->
            <link href="../css/bootstrap.min.css" rel="stylesheet">
            <!-- Bootstrap theme -->
            <link href="../css/bootstrap-theme.min.css" rel="stylesheet">
			<script src="../js/jquery.form-validator.js"></script>
			<script> $.validate(); </script>

    </head>
<?php

session_start();
if (isset($_SESSION['autenticado'])){
    header('Location:http://localhost/gramajo/Vistas/menu.php');
}
//else{
//    header('Location:http://localhost/gramajo/Vistas/index.php');
//}
    
?>
<body>

  <div class="container theme-showcase" role="main">
		<div class="page-header">
			<h1>Login</h1>
		</div>
      <form id="form1" name="form1" action="" method="POST" align="Center">
			<div class="alert alert-success" align="center">
					<div class="lista">
						<br>
						<ul class="list-group">
							<li class="list-group-item active" ><h3> Datos del Usuario</h3></li>
							<li class="list-group-item">
								Usuario:
                                                                <input type="text" id="txtUser" name="txtUser" value="" class="alert alert-warning" />
							</li>
							<li class="list-group-item">
								Contraseña:
                                                                <input type="password" id="txtPassword" name="txtPassword" value="" class="alert alert-warning" />
							</li>
							<li class="list-group-item active">
								 <input type="submit" value="Aceptar" name="btnConfirm" class="btn btn-success" /><!-- onclick="return btnConfirm_onclick()"-->
								 <input type="reset" value="Cancelar" name="btnCancel" class="btn btn-success" />
							</li>
						</ul>
					</div>	
				</div>
		</form>
		<button class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal">
			Registrar Nuevo Usuario
		</button>    
	</div> 
 
           

<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Registrar Usuario</h4>
      </div>
      <div class="modal-body">
        <div class="modal_register">
			  <form id="form_register" method="post" action="index.php">
				   <ul class="list-group">
					  <li class="list-group-item">
							  Nombre y Apellido:
							  <input id="nombre" type="text" name="nombre" value="" class="alert alert-warning" required/>
					  </li>
                                          <li class="list-group-item" id="loginDiv">
							  Nombre de Usuario:
                                                          <input id="login" type="text" name="login" value="" class="alert alert-warning" required/>
					  </li>
                                          <li class="list-group-item">
							  Clave:
                                                          <input id="clave1" type="password" name="clave1" value="" class="alert alert-warning" required/>
					  </li>
					  <li class="list-group-item" id="clave2Div">
							  Re-Clave:
                                                          <input id="clave2" type="password" name="clave2" value="" class="alert alert-warning" required/>
					  </li>
					   <li class="list-group-item">
							  Mail:
                                                          <input id="mail" data-validation="email" type="text" name="mail" value="" class="alert alert-warning" required/>
					  </li>
				  </ul>
			  </form>
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
        <button type="button" class="btn btn-primary" id="registrarUsuario">Guardar</button>
      </div>
    </div>
  </div>
</div>

<script src="../js/usuariosController.js"></script>

   </body>
</html>

