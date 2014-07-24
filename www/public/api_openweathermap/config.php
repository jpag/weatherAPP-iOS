<?php

	$STATE = 'dev';
	$DAYSSAVED = '20 days';
	
	$CACHEFOLDER = 'cache/';
	$CACHEEXPIRE_CRON = '2 hours';
	
	$AUTH_TOKEN = '0f1973f06fbe819aed7072b50c622973';
	
	//auto detect states
	if( strpos( $_SERVER['HTTP_HOST'], 'local' ) === false ){
		$STATE = 'live';
	}

	//database setup:
	if( $STATE == 'dev' ){
		
		
	}else if( $STATE == 'live' ){
		
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