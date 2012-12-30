<?php	
	
	//IOS REQUEST to get the full list of CITIES available (do the math of gps matching to cities on the iphone side)
	require_once('json_header.php');
	require_once('config.php');
	//AUTO SCRIPT TO PULL TWEETS
	$cacheFile = $CACHEFOLDER."cities.json";
	dieAndCacheIfNotExpired($cacheFile);

	//script runs through array of cities to pull
	require_once('db_connect.php');
	

	//GET CITIES:
	$sql  = "SELECT id, city, state, country, lat, lng, zipcode ";
	$sql .= "FROM cities";
	
	$citiesSQL = mysql_query($sql);
	if (mysql_errno()){
		message('error', array(
								"type"=>"error",
								"mysql_type"=> mysql_errno() , 
								"sql"=>$sql , 
								"message"=>mysql_error() 
								)
				);
		die;
	}

	$cities = array();
	
	if( mysql_num_rows($citiesSQL) > 0 ){

		while( $city = mysql_fetch_array( $citiesSQL ) ) {
			//echo $city['id'] . ' ' . $city['city'] . ' ' . $city['state'] . ' ' . $city['country'] . ' ' . $city['lat'] . ' ' . $city['lng'];
			$cities['cities'][] = array(	
											'id' => $city['id'], 
											'name' => $city['city'],
											'state' => $city['state'],
											'country' => $city['country'],
											'lat' => $city['lat'],
											'lng' => $city['lng'],
											'zip' => $city['zipcode']
										);
		};
	}
	$cities['type'] = 'cities';
	$cities['cacheDate'] = strtotime($CACHEEXPIRE_CITIES);
	$citiesJSON = json_encode($cities);

	echo $citiesJSON;
	
	//write to cache file:
	$fh = fopen($cacheFile, 'w') or die(json_encode("error"));
	fwrite($fh, $citiesJSON );
	fclose($fh);

?>