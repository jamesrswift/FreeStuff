<?php

class API_ExampleAuthedMethod extends API_Method_AuthenticationRequired{
	
	public $required_arguments = array(); // Put the required arguments in here.
	
	public function NotAuthed( $badkey ){
		return "This is output if the key provided ($badkey) doesn't work!";
	}
	
	public function Authed( $key ){
		return "This is output if $key is a valid key";
	}
	
	
	// DO NOT OVERRIDE ::CHECK( )
	
	// DO NOT OVERRIDE ::OUTPUT( )
}

$API->AddMethod( "secret", "API_ExampleAuthedMethod" );

?>