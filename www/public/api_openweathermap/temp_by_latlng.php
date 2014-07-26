<?php	
	require_once('json_header.php');
	
	//recieve incoming LAT LONG and determine closest city.
	if( !isset( $_REQUEST['lat'] ) || !isset( $_REQUEST['lng'] ) ){
		echo json_encode(array('error' => 'latitude and longitude not defined' ));
		die;
	}

	if( !isset( $_REQUEST['unit'] ) ){
		// auto = Selects the relevant units automatically, based on geographic location.
		$UNITOFMEASUREMENT = 'auto';
	} else {
		$unit = strtolower( $_REQUEST['unit'] );
		if( $unit == 'si' ) {
			$UNITOFMEASUREMENT = 'si';
		} else {
			$UNITOFMEASUREMENT = 'us';
		}
	}

	// set a default to convert from (don't rely on the API for conversion)
	$UNITOFMEASUREMENT = 'metric';

	require_once('config.php');
	require_once('openweather-api.php');
	
	//$TIMESTAMP = gmdate( time() );
	$FROMTIME = gmdate( strtotime('-1 day -1 hour') );
	
	$OPENWEATHER = new openWeather(
		array(
			"ACCESS_TOKEN"=> $AUTH_TOKEN ,
			"CACHEEXPIRES" => $CACHEEXPIRE_CRON ,
			"OVERRIDECACHE" => false,
			"CACHEFOLDER" => $CACHEFOLDER,
			"PARAMS" => array('units'=>$UNITOFMEASUREMENT ),
			//"TIME" => $TIMESTAMP,
			"FROMTIME" => $FROMTIME
		)
	);

	// exclude=[blocks]: Exclude some number of data blocks from the API response. 
	// [blocks] should be a comma-delimeted list (without spaces) of any of the following: 
	// currently, minutely, hourly, daily, alerts, flags.
	
	// ROUND the LATs and LONGs
	$LAT = round($_REQUEST['lat']);
	$LNG = round($_REQUEST['lng']);
	
	$RESULT = $OPENWEATHER->queryGPS( array($LAT, $LNG) );
	echo $RESULT;

?>