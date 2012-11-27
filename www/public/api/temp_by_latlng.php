<?php	
	//recieve incoming LAT LONG and determine closest city.
	if( !isset( $_REQUEST['lat'] ) || !isset( $_REQUEST['lng'] ) ){
		echo json_encode(array('error' => 'latitude and longitude not defined' ));
		die;
	}

	echo $_REQUEST['lat'];
	echo ' --- ';
	echo $_REQUEST['lng'];
	
?>