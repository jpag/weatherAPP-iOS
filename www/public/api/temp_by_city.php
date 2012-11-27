<?php 
	
	require_once('json_header.php');

	//echo $_REQUEST['city'];
	if( !isset( $_REQUEST['city'] ) ){
		echo json_encode(array('error' => 'city not defined' ));
		die;
	}

	require_once('config.php');
	
	$cacheFile = $CACHEFOLDER."city_temp_".strtolower( $_REQUEST['city'] ).".json";
	//now check for the cache and create one if needed:
	dieAndCacheIfNotExpired($cacheFile);


	//script runs through array of cities to pull
	require_once('db_connect.php');
	
	//GET CITIES:
	//$sql  = "SELECT id, city, state, country, lat, lng, zipcode";
	$sqlFindCity  = "SELECT cities.id, cities.city, temps.date_stamp, temps.temperature, temps.city_id ";
	
	//DO WE NEED ALL THIS:
	$sqlFindCity .= ", cities.zipcode, cities.lat, cities.lng, cities.country, cities.state ";
	
	$sqlFindCity .= "FROM cities LEFT JOIN temps ";
	$sqlFindCity .= "ON cities.id = temps.city_id ";
	$sqlFindCity .= "WHERE LOWER(cities.city) = LOWER('".$_REQUEST['city']."') ";
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
												'temp' => $cityTemp['temperature'] 
											);
		}	
		$decodedTemps['city'] = $city;
		if( $STATE == 'dev' ){
			$decodedTemps['mysql'] = $sqlFindCity;
		}

		echo json_encode($decodedTemps );

	}else{
		if( $STATE == 'dev' ){
			echo json_encode(array("error_sql" , $sqlFindCity ));
		}else{
			echo json_encode(array("error" , "we did not find any reference to this city" ));	
		}
		

		die;
	}


?>