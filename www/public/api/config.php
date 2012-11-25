<?php
	$STATE = 'live';
	$DAYSSAVED = '7 days';
	
	$CACHEEXPIRE = '24 hours';
	$AUTH_TOKEN = 'f37a11b8a4173144122111';
	
	//auto detect states
	if( strpos( $_SERVER['HTTP_HOST'] , 'local') >= 0 ){
		$STATE = 'dev';
	}

	//database setup:
	if( $STATE == 'dev' ){
		
		$DB_USER = 'root';
		$DB_PASS = 'root';
		$DB_HOST = 'localhost';
		$DB_NAME = 'weatherapp';

	}else if( $STATE == 'live' ){
		
		$DB_USER = 'root';
		$DB_PASS = 'root';
		$DB_HOST = 'localhost';
		$DB_NAME = 'weatherapp';

	}


	function message($type, $msg){
		echo(	json_encode(array($type=>$msg))   );
	}


?>