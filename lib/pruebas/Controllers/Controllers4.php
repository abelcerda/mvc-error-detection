<?php
    require ("../Clases/class.phpmailer.php");
    require ("../Clases/class.pop3.php");
    require ("../Clases/class.smtp.php");
    require ("../Clases/PHPMailerAutoload.php");
    require ("../Conexion/config.php");
    require ("usuariosController.php");
    $resultado= Null;
    
    $user = new controllerUsuario();
    
    switch ($_REQUEST['accion']){
        case "agregar":
            $resultado=$user->agregar($_POST['nombre'],$_POST['login'],$_POST['clave1'],$_POST['mail']);
            break;
        case "validar-login";
            $resultado=$user->validarLogin($_POST['login']);
            break;
        case "validar-claves":
            $resultado = $user->validarClaves($_POST['clave1'],$_POST['clave2']);
            break;
        case "login":
            $resultado = $user->login($_POST['user'], $_POST['password']);
            break;
        default:
            break;
    }
        
    echo $resultado;
 ?>
