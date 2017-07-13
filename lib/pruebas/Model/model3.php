<?php

class UpdateStates extends Mage_Shell_Sync_Abstract{
	protected static $config;
	
	

        public function __destruct()
        {
          if ($this->_mysql_conn){
                  mysql_close($this->_mysql_conn);
              }
        }
	

	
	protected function setState($idPedido, $state, $status){

		
			
			$pedidoQuery = $this->basededatos->fetchall("SELECT * FROM sales_flat_order WHERE increment_id='".$idPedido."'");
			if(!($pedido = mysql_fetch_row($pedidoQuery))){
				return "No existe el pedidoi: $idPedido";	
			}
			$res1 = $this->fetchcolumn("UPDATE sales_flat_order_grid SET status='".$status."' WHERE increment_id='".$idPedido."'");
			$res2 = $this->_execute("UPDATE sales_flat_order SET state='".$state."' , status='".$status."' WHERE increment_id='".$idPedido."'");

			if($res2 == 1){
				return "Actualizado $idPedido: $state, $status";
			}
			return "Error al actualizar el pedido";

	}

	public function updateState($idPedido,$stateCode){

		$output = $_POST["param1"];
		
		
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