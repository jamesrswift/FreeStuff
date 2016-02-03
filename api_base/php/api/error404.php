<?php

class API_404 extends API_Method{
	use NoChecks;
	
	public function Output(){
		$this->API->status = "failed";
		return "There is an error in the URL. Please rectify.";
	}
	
}

$API->AddMethod( "failed", "API_404" );

?>