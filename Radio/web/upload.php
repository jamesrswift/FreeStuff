<!DOCTYPE html>
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
			Upload to radio
		</h2>

<?php

error_reporting(E_ALL);

ini_set('display_errors', true);


if(isset($_POST["submit"])) {

	$target_dir = dirname(__FILE__) . "\\media\\";
	$target_file = $target_dir . strtr(basename($_FILES["fileToUpload"]["name"]),'àáâãäçèéêëìíîïñòóôõöùúûüýÿÀÁÂÃÄÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜÝ','aaaaaceeeeiiiinooooouuuuyyAAAAACEEEEIIIINOOOOOUUUUY');
	$uploadOk = 1;
	$message = 'There was an error while trying to upload your file';
	
	if (file_exists($target_file)) {
		echo "<p>Your upload has failed! The file that you are trying to upload already exists on the server (or a file of the same name does). If you are certain that this song is not already on the radio, please change the name of the file you are trying to upload and try again.</p>";
		$uploadOk = 0;
	}

	$FileType = pathinfo($target_file,PATHINFO_EXTENSION);
	if($FileType == "mp3") {
		$uploadOk = $uploadOk and 0 or 1;
	} else {
		echo "<p>The song you are trying to upload must be an MP3 file! Please convert the song you are trying to upload to this format.</p>";
		$uploadOk = 0;
	}
	
	if (!is_file($_FILES['fileToUpload']['tmp_name'])) {
        echo '<p>Debug: ', $_FILES['fileToUpload']['tmp_name'], ' file not found', "<p/><br>";
		switch( $_FILES['fileToUpload']['error'] ) {
            case UPLOAD_ERR_OK:
                $message = false;;
                break;
            case UPLOAD_ERR_INI_SIZE:
            case UPLOAD_ERR_FORM_SIZE:
                $message .= ' - file too large (limit of '.ini_get('upload_max_filesize').' bytes). </p>';
				$uploadOk = 0;
                break;
            case UPLOAD_ERR_PARTIAL:
                $message .= ' - file upload was not completed. </p>';
				$uploadOk = 0;
                break;
            case UPLOAD_ERR_NO_FILE:
                $message .= ' - zero-length file uploaded. </p>';
				$uploadOk = 0;
                break;
            default:
                $message .= ' - internal error #'.$_FILES['fileToUpload']['error'].'. Please try again later</p>';
				$uploadOk = 0;
                break;
        }
		print $message;
	}
	
	if ($uploadOk == 0) {
		echo "<p>Sorry, your file was not uploaded." . $message;
	} else {
		if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file)) {
			echo "<p>The file ". basename( $_FILES["fileToUpload"]["name"]). " has been uploaded. It is now available to be played on the radio. Have a nice day!";
		} else {
			echo "<p>Sorry, there was an error uploading your file." . $message;
		}
	}

}else{

print('
			Select a song to upload to the radio:<br>
			<div class="custom_file_upload center">
				<form action="upload.php" method="post" enctype="multipart/form-data">
					<input type="file" class="file" name="fileToUpload" id="fileToUpload">
					<div class="file_upload">
						<input type="submit" value="Upload song" name="submit">
					</div>
				</form>
			</div>');

};

?>


	</div>
	<div id="footer">
		Copyright © James Swift, 2015
	</div>
</div>

</body>
</html>

