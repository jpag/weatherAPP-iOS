<?php 
	//DISPLAYS CITY and most recent TEMPERATURES
	// can pass either a city name or ID
	//OUTPUTS JSON:	

	require_once('json_header.php');

	require_once('config.php');
	
	//DETERMINE HOW TO MATCH CITY by NAME or CITY ID:

	if( isset($_REQUEST['city']) ):
		$cacheFile = $CACHEFOLDER."city_temp_".strtolower( $_REQUEST['city'] ).".json";
		$sqlFindCityWhereFilter = "WHERE LOWER(cities.city) = LOWER('".$_REQUEST['city']."') ";
	elseif( isset($_REQUEST['id'] ) ):
		$cacheFile = $CACHEFOLDER."city_temp_".strtolower( $_REQUEST['id'] ).".json";
		$sqlFindCityWhereFilter = "WHERE cities.id = ".$_REQUEST['id']." ";
	else:
		echo json_encode(array(
								'error' => 'city not defined' ,
								'days' => null,
								"city" => null
						));
		die;
	endif;


	//now check for the cache and create one if needed:
	//echo $cacheFile;
	dieAndCacheIfNotExpired($cacheFile);

	//script runs through array of cities to pull
	require_once('db_connect.php');
	
	//GET CITIES:
	//DO WE NEED ALL THIS:
	//$sql  = "SELECT id, city, state, country, lat, lng, zipcode";

	$sqlFindCity  = "SELECT cities.id, cities.city, temps.date_stamp, temps.temperature, temps.city_id ";
	$sqlFindCity .= ", cities.zipcode, cities.lat, cities.lng, cities.country, cities.state ";
	$sqlFindCity .= "FROM cities LEFT JOIN temps ";
	$sqlFindCity .= "ON cities.id = temps.city_id ";
	$sqlFindCity .= $sqlFindCityWhereFilter;
	$sqlFindCity .= "ORDER BY temps.date_stamp DESC";

	$cityTemps = mysql_query($sqlFindCity);
	
	$decodedTemps = array();

	if( $cityTemps && mysql_num_rows($cityTemps) > 0 ){
		
		//$decodedTemps['city']['cityname'] = $cityArray[0]['city'];
		//$decodedTemps['city']['id'] = $cityArray[0]['city_id'];
		//$decodedTemps[['city']'zip'] = $cityArray[0]['cities.zipcode'];

		$city;

		while( $cityTemp = mysql_fetch_array( $cityTemps ) ) {
			if( !isset($cityData)){
				$city = array(  'id' => $cityTemp['city_id'],
								//DO WE NEED ALL THIS:
								'name' => $cityTemp['city'],
								'state' => $cityTemp['state'],
								'country' => $cityTemp['country'],
								'lat' => $cityTemp['lat'],
								'lng' => $cityTemp['lng'],
								'zip' => $cityTemp['zipcode']
							);
			}

			$decodedTemps['days'][] = array( 
												'date' => $cityTemp['date_stamp'] , 
												'temp' => array( "c" => $cityTemp['temperature'] + 0,
																"f" => ( convertCelToFaren( $cityTemp['temperature'] ) )
																)
											);
		}	
		$decodedTemps['city'] = $city;
		if( $STATE == 'dev' ){
			$decodedTemps['mysql'] = $sqlFindCity;
		}

		echo json_encode($decodedTemps );

	}else{
		$errorMsg = array(
							"days"=> null,
							"city" => null,
							"error" => "we did not find any reference to this city"
						);
		if( $STATE == 'dev' ){
			$errorMsg['sql'] = $sqlFindCity;
		}	
		echo json_encode( $errorMsg );	
		die;
	}


?>