<?php
header( "Content-Type: text/plain" );
include "php/api.class.php";

$API = new API;
include "php/api/api.php";
$API->Run();

?>