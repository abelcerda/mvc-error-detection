<?php
    require ("../Clases/class.phpmailer.php");
    require ("../Clases/class.pop3.php");
    require ("../Clases/class.smtp.php");
    require ("../Clases/PHPMailerAutoload.php");
    require ("../Conexion/config.php");
    require ("usuariosController.php");
    $resultado= Null;
    
    $user = new controllerUsuario();
    
    if ($_REQUEST['accion'] == "agregar") {
      $resultado = $user->agregar($_POST['nombre'],$_POST['login'],$_POST['clave1'],$_POST['mail']);
    } else {
      $resultado = $user->validarLogin($_POST['login']);
    }
        
    echo $resultado;
 ?>
