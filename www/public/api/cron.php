<?php

	//header('Content-type: application/json');
	//header("Expires: Tue, 01 Jan 2000 00:00:00 GMT");
	//header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
	//header("Cache-Control: post-check=0, pre-check=0", false);
	//header("Pragma: no-cache");

	//script runs through array of cities to pull

	require_once('config.php');
	require_once('db_connect.php');
	require_once('weather-api-class.php');

	//GET CITIES:
	$sql  = "SELECT id, city, state, country, lat, lng, zipcode ";
	$sql .= "FROM cities";
	
	//$sql .= "WHERE ";
	//pseudo code $sql .= " WHERE time > FROM_UNIXTIME( now + cachetime )";

	$cities = mysql_query($sql);
	if (mysql_errno()){
		message('error', array("type"=> mysql_errno() , "sql"=>$sql , "message"=>mysql_error() ) );
		die;
	}

	//for CRON OVERRIDECACHE = true;
	$WORLDWEATHER = new worldweather(
		array(
		"ACCESS_TOKEN"=> $AUTH_TOKEN ,
		"CACHEEXPIRES" => $CACHEEXPIRE ,
		"OVERRIDECACHE" => false
		)
	);

	$dateToday = date('Y-m-d');

	while( $city = mysql_fetch_array( $cities ) ) {
		//echo $city['id'] . ' ' . $city['city'] . ' ' . $city['state'] . ' ' . $city['country'] . ' ' . $city['lat'] . ' ' . $city['lng'];
		
		$RESULT = $WORLDWEATHER->queryGPS( array( 
												$city['lat'], 
												$city['lng']
											), 
											$city['id'].'_'.$city['city'] 
										);
		
		$RESULT_DECODED = json_decode($RESULT);
		$tempNowInCelsius = $RESULT_DECODED->data->current_condition[0]->temp_C;

		//INSERT updated result
		$sql_insert_temp = "INSERT INTO temp_each_day (city_id, temperature, date_stamp ) ";
		$sql_insert_temp .= "VALUES ( ".$city['id']." , ".$tempNowInCelsius.", '".$dateToday."' )";

		$insertTemp = mysql_query($sql_insert_temp);

		//do we care about multiple crons of the same day? not really...
	}

	//NOW CLEAN UP. REMOVE any older dates no longer needed (older then 8 days.)


?>
