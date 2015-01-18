<?php
	$STATE = 'dev';
	$DAYSSAVED = '20 days';
	
	$CACHEFOLDER = 'cache/';
	$CACHEEXPIRE_CRON = '2 hours';
	
	// FORECAST.IO
	$WEATHER_API_AUTH_TOKEN = '135a9db207f662dfed4d028f503b562e';
	

	//auto detect states
	if( strpos( $_SERVER['HTTP_HOST'], 'local' ) === false ){
		$STATE = 'live';
	}

	//database setup:
	if( $STATE == 'dev' ){
		
		$DB_USER = 'root';
		$DB_PASS = 'root';
		$DB_HOST = 'localhost';
		$DB_NAME = 'weather_forecastcache';

	}else if( $STATE == 'live' ){
		
		$DB_USER = 'db162706_weather';
		$DB_PASS = 'kiera2010';
		$DB_HOST = 'internal-db.s162706.gridserver.com';
		$DB_NAME = 'db162706_weatherapp';

		//CHANGE THIS?
		$CACHEFOLDER = 'cache/';
	}


	function message($type, $msg){
		echo( json_encode(array($type=>$msg)) );
	}

	function dieAndCacheIfNotExpired($cacheFile){
		//if date is not old enough:
		if( file_exists($cacheFile) ){
			$cacheJSON = file_get_contents($cacheFile);
			$decodedCache = json_decode($cacheJSON, true);
		
			if( $decodedCache['cacheDate'] > time('now') ){
				//not enough time to query again
				//display cache and die/stop query:
				echo $cacheJSON;
				die;
			}
		}
	}

	//calculations convert Temperatures - C to F or - F to C.
	function convertFarenToCel($f){
		return ( (( $f + 40 ) * 5/9 ) - 40);
	}
	function convertCelToFaren($c){
		return ( (( $c + 40 ) * 9/5 ) - 40 );
	}

?>