<?php

ob_start();

include "error.enum.php";

class API{
	
	/** Private */
	private $methods = array();
	
	private function GetCurrentMethod( ){
		foreach ( $this->methods as $Key=>$Value ){
			if ( isset($_GET[$Key]) ) return $Key;
		}
		return "Error";
	}
	
	private function GetInputTable( ){
		if ( count( $_POST ) !== 0 ){
			return $_POST;
		}
		return $_GET;
	}
	
	/** Public */
	
	public $input = array();
	public $status;
	public $errorcode;
	public $errormessage;
	
	public function AddMethod( $sName, $fCallable ){
		if ( isset($this->methods[$sName]) ) return API_ErrorEnum::MethodAlreadyExists;
		
		$this->methods[$sName] = $fCallable;
		return API_ErrorEnum::Success;
	}
	
	public function BuildOutput( $Success, $Name, $Output, $Base64 = false ){
		$output = array();
		$output["status"] = $Success ? "success" : "error";
		
		if ( isset( $this->status ) ){
			$output["status"] = $this->status;
		}
		
		if ( $Success and ( !isset($this->status) or $this->status == "success" )){
			$output["name"] = $Name;
			
			if ( $Base64 and gettype( $Output ) == "string" ){
				$output["output"] = base64_encode( $output );
			}else{
				$output["output"] = $Output;
			}
		}else{
			$output["code"] = $Name;
			$output["output"] = $Output;
			
			if ( isset( $this->errorcode ) ){
				$output["status"] = $this->errorcode;
			}
			
			if ( isset( $this->errormessage ) ){
				$output["output"] = $this->errormessage;
			}
		}
		return $output;
	}
	
	public function HandleExecution( $sName ){
		if ( !isset($this->methods[$sName]) ) return API_ErrorEnum::NoMethodExists;
		
		$method = null;
		if ( gettype( $this->methods[$sName] ) == "string" ){
			$method = new $this->methods[$sName];
		}else{
			$method = $this->methods[$sName]();
		}
		$method->SetParent( $this );
		$method->InitiateDatabase( );
		
		if ( $method->Check() ){
			return $method->Output( );
		}
		
		return API_ErrorEnum::MethodFailedChecks;
	}
	
	public function Run( ){
		$this->input = $this->GetInputTable( );
		$Name = $this->GetCurrentMethod( );
		$Output = $this->HandleExecution( $Name );
		
		ob_clean();
		if ( gettype($Output) == "array" or gettype($Output) == "string" ){
			print( json_encode($this->BuildOutput( true, $Name, $Output ), JSON_PRETTY_PRINT) );
		}else{
			print( json_encode($this->BuildOutput( false, $Output, "Something went wrong with your query" ), JSON_PRETTY_PRINT) );
		}
	}
}

?>