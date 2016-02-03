<?php


require "getid3/getid3.php";

if (isset($_GET["s"])){
	foreach(scandir ( "media/") as $value){
		if ($value != "." and $value != ".." and $value != ".HTACCESS" ){
			$getID3 = new getID3;
			$ThisFileInfo = $getID3->analyze("media/".$value);
		
			print( pathinfo($value, PATHINFO_FILENAME) . "\t" . @$ThisFileInfo['playtime_string'] .";" );
		}
	}
}else{

print '<!DOCTYPE html>
<html>
<HEAD>
    <LINK href="style.css" rel="stylesheet" type="text/css">
  </HEAD>
<body>

<div id="container">
	<div id="header">
		<h1>
			PrimeServer Radio
		</h1>
	</div>

<div id="content">
		<h2>
			Songs available on the radio
		</h2>';

print('<p><div class="SongList" >
                <table >
                    <tr>
                        <td>
                            Song Name
                        </td>
                        <td >
                            Length
                        </td>
                    </tr>');
			
		foreach(scandir ( "media/") as $value){
			if ($value != "." and $value != ".." and $value != ".HTACCESS" ){
				$getID3 = new getID3;
				$ThisFileInfo = $getID3->analyze("media/".$value);
			
				print( "<tr><td>$value</td><td>".@$ThisFileInfo['playtime_string'] ."</td></tr>" );
			}
		}
		
print('
                </table>
            </div></p>
          ');
		  
print '</div>
	<div id="footer">
		Copyright © James Swift, 2015
	</div>
</div>

</body>
</html>';

}


?>