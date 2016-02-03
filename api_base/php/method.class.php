<?php

abstract class API_Method{
	
	/** Overrides */
	abstract public function Check();
	abstract public function Output();
	
	/** Protected */
	protected $API;
	protected $Database;
	
	protected function GetInput( $Name ){
		if ( isset( $this->API ) and isset( $this->API->input[ $Name ] )){
			return $this->API->input[ $Name ];
		}
	}	
	
	/** Public */
	public function SetParent( $API ){
		$this->API = $API;
	}
	
	public function InitiateDatabase( ){
		if ( isset($this->UseDatabase) and $this->UseDatabase == true ){
			try{
				ob_start();
				$this->Database = new PDO('mysql:host=hostname;dbname=ssldb','username','password'); /** Fill this in */
				$this->Database->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
			}
			catch (PDOException $e)  
			{ 
				ob_clean();
				die( json_encode($this->API->BuildOutput( false, "MySQL Error", $e->getMessage() ), JSON_PRETTY_PRINT));  
			}
		}
	}

}

abstract class API_Method_AuthenticationRequired extends API_Method{
	
	public $required_arguments = array();
	
	abstract public function NotAuthed( $badkey ); // called if not
	abstract public function Authed( $key ); // Called if authenticated
	
	public function Authenticate( $key ){
		// Return true if authenticated
		return true;
	}
	
	public function Check(){
		if ( null == $this->GetInput("key") ) return false;
		foreach ( $this->required_arguments as $Key=>$Value ){
			if ( null == $this->GetInput($Value) ) return false;
		}
		return true;
	}
	
	public function Output(){
		if ( $this->Authenticate( $this->GetInput("key") ) ){
			return $this->Authed( $this->GetInput("key") );
		}else{
			return $this->NotAuthed( $this->GetInput("key") );
		}
	}
}

trait NoRequiredArguments{
	public $required_arguments = array();
}

trait Database{
	protected $UseDatabase = true;
}

trait DefaultNoAPIKeyMessage{
	public function NotAuthed( $badkey ){
		$this->API->status = "badkey";
		return "The key you supplied ($badkey) is not valid.";
	}
}

trait NoChecks{
	public function Check(){ return true; }
}

?>