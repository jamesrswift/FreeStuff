<?php

class API_ExampleTraitMethod extends API_Method_AuthenticationRequired{
	use Database, DefaultNoAPIKeyMessage;
	
	public $required_arguments = array("id");
	
	public function Authed( $key ){
		
		$ID = $this->GetInput("id");

		$prepstatement = $this->Database->prepare( 'SELECT * FROM gm_user WHERE ID = :ID' );
		$prepstatement->bindParam(":ID", $ID);
		$prepstatement->execute();
		
		$array = $prepstatement->fetch( );
		
		foreach ( $array as $key=>$value ){
			if ( gettype( $key ) == "integer" ){
				unset( $array[$key] );
			}
		}
		
		return $array;
	}
}

$API->AddMethod( "test", "API_ExampleTraitMethod" );


?>