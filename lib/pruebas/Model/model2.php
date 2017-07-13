<?php

require_once ("config.php");
require_once ("abstract.php");
require_once('../../app/Mage.php');
Mage::app();

class LoadDaysPerStore extends Mage_Shell_Sync_Abstract{

	private $file;
	private $writeDB;
	private $readDB;
	private $deliverydays;
	private $tiendas_id;
	private $columns = array();

	function __construct(){
		$this->readDB 			= Mage::getSingleton('core/resource')->getConnection('core_read');
		$this->writeDB 			= Mage::getSingleton('core/resource')->getConnection('core_write');
		$this->deliverydays 	= Mage::getSingleton('core/resource')->getTableName('init_dias_entrega_especial');
		AbacusConfig::init();
	}

	public function run(){
		$all_files = scandir(AbacusConfig::get('products_path'));
		foreach($all_files as $afile){
			if($this->_filtrarFicheros($afile, "daysperstore_2016")){
				$this->file = AbacusConfig::get('products_path')."/".$afile;
			}
		}
		$this->saveDaysPerStore();
	}

	public function saveDaysPerStore(){
		if (($gestor = fopen($this->file, "r")) !== FALSE) {

			$this->columns = fgetcsv($gestor, 1000, ";");
			$operation = array_pop($this->columns);
			
		    while (($this->datos = fgetcsv($gestor, 1000, ";")) !== FALSE) {

	        	$operation = array_pop($this->datos);

	        	switch ($operation) {
	        		case 'insert':
	        			$this->insertData();
	        			break;
	        		case 'update':
	        			$this->updateData();
	        			break;
	          		case 'delete':
	        			$this->deleteData();
	        			break;
	        	}
		        
		    }
		    fclose($gestor);
		}
	}

	public function insertData(){
		//REPLACE INTO test VALUES (1, 'Old', '2014-08-20 18:47:00');
		$this->query = "INSERT INTO {$this->deliverydays} (".implode(',',$this->columns).") VALUES ";

		foreach ($this->datos as $value) {
    		$dataToSave[] = !mysql_real_escape_string($value)? "'".$value."'" : NULL;	
    	}
    	$this->query .= "(".implode(",",$dataToSave).")"; 
    	
		if($this->writeDB->query($this->query))
			print_r("Guardando la siguiente query: ".$this->query."\n");
	}

	public function updateData(){
		$this->query = "UPDATE {$this->deliverydays} SET";

		$data = array_combine($this->columns, $this->datos);

		foreach ($data as $key => $value) {
    		if(!mysql_real_escape_string($value)){
    			if ($key == "fecha")
    				$query_condition[] = " {$key}='{$value}' ";
    			elseif($key == "init_tiendas_id")
    				$query_condition[] = " {$key}='{$value}' ";
    			else
    				$query_values[] = " {$key}='{$value}' ";
    		}
    	}
    	$this->query .= implode(",",$query_values); 
    	$this->query .= " WHERE ".implode(' AND ',$query_condition);
		if($this->writeDB->query($this->query,$query_values))
			print_r("Query de actulizacion: ".$this->query."\n");
	}

	public function deleteData(){
		$this->query = "DELETE FROM {$this->deliverydays}";

		$data = array_combine($this->columns, $this->datos);

		foreach ($data as $key => $value) {
    		if(!mysql_real_escape_string($value)){
    			if ($key == "fecha")
    				$query_condition[] = " {$key}='{$value}'";
    			elseif ($key == "init_tiendas_id") 
    				$query_condition[] = " {$key}='{$value}'";
    		}
    	}
 
    	$this->query .= " WHERE ".implode(" AND ",$query_condition);
		if($this->writeDB->query($this->query,$query_condition))
			print_r("Query de borrado: ".$this->query."\n");
	}
}


$m = new LoadDaysPerStore();
$m->run();