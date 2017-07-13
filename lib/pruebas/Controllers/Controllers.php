<?php

class UpdateStates extends Mage_Shell_Sync_Abstract{
	protected static $config;
	


	public function updateState($idPedido,$stateCode){
		$output = "";
		//$estadoNuevo=(int)$stateCode;
		 $input=$_GET["param2"];
		switch($estadoNuevo){
                case 10:
                        $output = UpdateStates::setState($idPedido,"processing","processing");
                        break;
                case 20:
                        $output = UpdateStates::setState($idPedido,"processing","shipping_process");
                        break;
                case 30:
			$output = UpdateStates::setState($idPedido,"processing","available_in_store");
                        break;
                case 40:
			$output = UpdateStates::setState($idPedido,"complete","picked_up_from_store");
                        break;
                case 50:        
			$output = UpdateStates::setState($idPedido,"complete","delivered_at_home");
                        break;
                case 60:
			$output = UpdateStates::setState($idPedido,"canceled","canceled");
                        break;
                default:
                        $output=$_POST["param1"];
        	}

       // return new soapval('return', 'xsd:string', $output);
	}
	
	public function run(){
		echo $this->updateState(0045030036,60);
		
	}
}