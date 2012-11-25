<?php	
	
	//IOS REQUEST to get the full list of CITIES available (do the math of gps matching to cities on the iphone side)


	header('Content-type: application/json');
	header("Expires: Tue, 01 Jan 2000 00:00:00 GMT");
	header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
	header("Cache-Control: post-check=0, pre-check=0", false);
	header("Pragma: no-cache");

	//script runs through array of cities to pull

	require_once('config.php');
	require_once('db_connect.php');
	
	//GET CITIES:
	$sql  = "SELECT id, city, state, country, lat, lng, zipcode ";
	$sql .= "FROM cities";
	
	//$sql .= "WHERE ";
	//pseudo code $sql .= " WHERE time > FROM_UNIXTIME( now + cachetime )";

	$citiesSQL = mysql_query($sql);
	if (mysql_errno()){
		message('error', array("type"=> mysql_errno() , "sql"=>$sql , "message"=>mysql_error() ) );
		die;
	}

	$cities = array();
	while( $city = mysql_fetch_array( $citiesSQL ) ) {
		//echo $city['id'] . ' ' . $city['city'] . ' ' . $city['state'] . ' ' . $city['country'] . ' ' . $city['lat'] . ' ' . $city['lng'];
		$cities['cities'][] = $city;
	};
	
	$cities['cachedate'] = strtotime('1 day');
	$citiesJSON = json_encode($cities);

	echo $citiesJSON;


?>