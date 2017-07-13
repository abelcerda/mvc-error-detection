<?php

class modelUsuario{

    Var $id;
    var $nombre;     //se declaran los atributos de la clase, que son los atributos del cliente
    var $login;
    Var $clave;
    var $mail;
    
    public function __construct($id='',$nombre='', $login='', $clave='', $mail='') {
        $this->id = $id;
        $this->nombre = $nombre;
        $this->login = $login;
        $this->clave = $clave;
        $this->mail = $mail;
    }

    public static function getUsuarios() {
	global $db;
	$result=$db->query("select * from usuarios"); // ejecuta la consulta para traer al cliente
        return $result; // retorna todos los clientes
    }

    function getUsuario($field='',$value=0) {
        global $db;
        if (($value!=0)&&($field!="")){
                $result=$db->query("select * from usuarios where $field = $value"); // ejecuta la consulta para traer al cliente 
                $usuario = $result->fetchAll();
                var_dump($usuario);
                $this->id=$usuario[0]['id'];
                $this->nombre=$usuario[0]['nombre'];
                $this->login=$usuario[0]['login'];
                $this->clave=$usuario[0]['clave'];
                $this->mail=$usuario[0]['mail'];
        }
    }
    
    function getUser($fieldsValues=array()) {
        global $db;
        $length=count($fieldsValues);
          $flag=TRUE;
          if ($length > 0){
            foreach ($fieldsValues as $key => $value) {
                if ($flag){
                  $query = "$key = $value";
                }else{
                  $query .= " AND $key = $value";
                }
                $flag=FALSE;
            }
            $result=$db->query("SELECT * FROM usuarios WHERE $query"); // ejecuta la consulta para traer al cliente
            $usuario = $result->fetchAll();
            if ($usuario){
                $this->id=$usuario[0]['id'];
                $this->nombre=$usuario[0]['nombre'];
                $this->login=$usuario[0]['login'];
                $this->clave=$usuario[0]['clave'];
                $this->mail=$usuario[0]['mail'];
            }else{
                $this->id=0;
                $this->nombre='';
                $this->login='';
                $this->clave='';
                $this->mail='';
            }
            
      }
                
        
    }

    		// metodos que devuelven valores
    function getID()
     { return $this->id;}
    function getNombre()
     { return $this->nombre;}
    function getLogin()
     { return $this->login;}
    function getClave()
     { return $this->clave;}
    function getMail()
     { return $this->mail;}

            // metodos que setean los valores
    function setNombre($val)
     { $this->nombre=$val;}
    function setLogin($val)
     {  $this->login=$val;}
    function setFecha($val)
     {  $this->clave=$val;}
    function setMail($val)
     {  $this->mail=$val;}

    function save() {
        if ($this->id!=''){ //si el objeto tiene un id nulo es xq viene del método agregar() del controllador, sino está seteado para actualizar un usuario
            $this->updateUsuario();
        }else{
            $this->insertUsuario();
//            return $this;
        }
    }

    private function updateUsuario(){
        global $db;
        $query="UPDATE usuarios SET nombre='$this->nombre', login='$this->login',clave='$this->clave',mail='$this->mail' where id = $this->id";
        $result=$db->query($query);
        return $result;
    }

    private function insertUsuario() { // inserta el cliente cargado en los atributos. Ya funca
        global $db;
        $query = "INSERT INTO usuarios VALUES ('','".$this->nombre."','".$this->login."','".$this->clave."','".$this->mail."');";
        $result = $db->query($query);
        return $result;
    }

    function delete(){
        global $db;
        if ($this->id!=''){  
            $result=$db->query("delete from usuarios where id = $this->id");
        }
        return $result;
    }

}
