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
	$UNITOFMEASUREMENT = 'si';

	/* Example of call
	* https://api.forecast.io/forecast/135a9db207f662dfed4d028f503b562e/40,-73,1381948190?exclude=minutely
	*/

	require_once('config.php');
	require_once('weather-api-class.php');
	
	$TIMESTAMP = gmdate( time() );
	$FROMTIME = gmdate( strtotime('-1 day') );
	
	$FORECAST = new forecast(
		array(
			"ACCESS_TOKEN"=> $WEATHER_API_AUTH_TOKEN ,
			"CACHEEXPIRES" => $CACHEEXPIRE_CRON ,
			"OVERRIDECACHE" => true,
			"CACHEFOLDER" => $CACHEFOLDER,
			"PARAMS" => array('exclude'=>'minutely,flags,daily', 'units'=>$UNITOFMEASUREMENT ),
			"TIME" => $TIMESTAMP,
			"FROMTIME" => $FROMTIME
		)
	);
	// exclude=[blocks]: Exclude some number of data blocks from the API response. 
	// [blocks] should be a comma-delimeted list (without spaces) of any of the following: 
	// currently, minutely, hourly, daily, alerts, flags.
	
	// ROUND the LATs and LONGs
	$LAT = round($_REQUEST['lat']);
	$LNG = round($_REQUEST['lng']);
	
	$RESULT = $FORECAST->queryGPS( array($LAT, $LNG) );
	echo $RESULT;

?>