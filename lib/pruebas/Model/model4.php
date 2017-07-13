<?php

class ConectarBD {
    
    private $host;
    private $dbname;
    private $dblogin;
    private $dbpassword;
    
    function __construct($host, $dbname, $dblogin, $dbpassword) {
        $this->host = $host;
        $this->dbname = $dbname;
        $this->dblogin = $dblogin;
        $this->dbpassword = $dbpassword;
    }
    
    function openDB() {
        try {
            $db = new PDO('mysql:host='.$this->host.';dbname='.$this->dbname.'',$this->dblogin,$this->dbpassword);
            
            $db->setAttribute(PDO::MYSQL_ATTR_USE_BUFFERED_QUERY, true);
            return($db);
        } catch (PDOException $e) {

            return null;
            
            exit();
        }
    }

}

?>
