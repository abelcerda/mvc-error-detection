<?php

require ("../Model/usuariosModel.php");

class controllerUsuario {

    function agregar($nombre, $login, $clave, $mail) {
        global $db;
        $userModel = new modelUsuario('',$nombre, $login, $clave, $mail);
        $userModel->save();

    }

    function validarLogin($entrada){
            global $db;
            $userModel = new modelUsuario();
        $parametros = array('login'=>"'".$entrada."'");
        $userModel->getUser($parametros);
            if($userModel->id != 0){
                $resultado=TRUE;
            }else{
                $resultado=false;
            }
            return $resultado;
        }

    function validarClaves($clave1, $clave2) {
        global $resultado;
        if ($clave1 == $clave2) {
            $resultado = TRUE;
        } else {
            $resultado = false;
        }
        return $resultado;
    }

    function login($user, $password) {
        global $db;
        $userModel = new modelUsuario();
        $parametros = array('login'=>"'".$user."'",'clave'=>"'".$password."'");
        $userModel->getUser($parametros);
        if ($userModel->id != 0) {
            $_SESSION['user'] = $userModel->login;
            $_SESSION['autenticado'] = 'yes';
//            $_SESSION['usuario'][] = $user;
//            $_SESSION['usuario'][] = $password;
//            header('Location:http://localhost/gramajo/Vistas/menu.php');
            return TRUE;
        } else {
//            return "<h1 class='alert alert-danger' >Nombre o Usuario Ingresado No valido </h1>";
            return false;
        }
    }

}

?>