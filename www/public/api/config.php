<?php
	$STATE = 'live';
	$DAYSSAVED = '7 days';
	
	$CACHEFOLDER = 'cache/';
	
	$CACHEEXPIRE_CRON = '23 hours';
	$CACHEEXPIRE_CITIES = '1 day';
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

		//CHANGE THIS?
		$CACHEFOLDER = 'cache/';
	}


	function message($type, $msg){
		echo(	json_encode(array($type=>$msg))   );
	}

	function dieAndCacheIfNotExpired($cacheFile){
		//if date is not old enough:
		if( file_exists($cacheFile) ){
			$cacheJSON = file_get_contents($cacheFile);
			$decodedCache = json_decode($cacheJSON, true);
		
			if( $decodedCache['cacheDate'] > time('now') ){
				//not enough time to query again, wait some more:
				echo $cacheJSON;
				die;
			}
		}
	}


?>