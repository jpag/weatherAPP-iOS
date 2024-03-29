<?php

	//script runs through array of cities to pull
	
	//require_once('json_header.php');

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
		"ACCESS_TOKEN"=> $WEATHER_API_AUTH_TOKEN ,
		"CACHEEXPIRES" => $CACHEEXPIRE_CRON ,
		"OVERRIDECACHE" => false,
		"CACHEFOLDER" => $CACHEFOLDER
		)
	);

	$dateToday = date('Y-m-d');
	echo $dateToday . ' <br>';

	while( $city = mysql_fetch_array( $cities ) ) {
		//echo $city['id'] . ' ' . $city['city'] . ' ' . $city['state'] . ' ' . $city['country'] . ' ' . $city['lat'] . ' ' . $city['lng'];

		//check to see if THIS cityID has been done for this day.
		$sql_city_alreadydone_today = 'SELECT id, city_id FROM temps WHERE date_stamp = "'.$dateToday.'" AND city_id = '.$city['id'];
		$alreadyDoneTodayResult = mysql_query($sql_city_alreadydone_today);
		//has it?
		if( mysql_num_rows($alreadyDoneTodayResult) > 0 ){
			echo '<br> already done for today '. $city['id'].'_'.$city['city'];
			/*
			while( $doneList = mysql_fetch_array( $alreadyDoneTodayResult ) ) {
				var_dump($doneList);
			}
			echo '<br><br>';
			*/
		}else{
			echo '<br> INSERT Today '. $city['city']. ' ';

			$RESULT = $WORLDWEATHER->queryGPS( array( 
													$city['lat'], 
													$city['lng']
												), 
												$city['id'].'_'.$city['city'] 
											);
			
			$RESULT_DECODED = json_decode($RESULT);
			$tempNowInCelsius = $RESULT_DECODED->data->current_condition[0]->temp_C;

			//INSERT updated result
			$sql_insert_temp = "INSERT INTO temps (city_id, temperature, date_stamp ) ";
			$sql_insert_temp .= "VALUES ( ".$city['id']." , ".$tempNowInCelsius.", '".$dateToday."' )";
			echo '     '. $sql_insert_temp;

			$insertTemp = mysql_query($sql_insert_temp);
			
			if (mysql_errno()){
				message('error', array("type"=> mysql_errno() , "sql"=>$sql_insert_temp , "message"=>mysql_error() ) );
				die;
			}else{
				echo ' sucess.';
			}
		}
	}

	//NOW CLEAN UP. REMOVE any older dates no longer needed (older then 8 days.)
	$oldestDate = strtotime("-".$DAYSSAVED, strtotime(date('Y-m-d') ));
	
	$sql_remove_old = "DELETE FROM temps ";
	$sql_remove_old .= "WHERE date_stamp < '".date('Y-m-d' , $oldestDate)."'";

	$removeOld_result = mysql_query($sql_remove_old);
	echo '<br><br>'.$sql_remove_old . '<br> num rows deleted/affected ' . mysql_affected_rows() . '<br>';

	if (mysql_errno()){
		message('error', array("type"=> mysql_errno() , "sql"=>$sql_insert_temp , "message"=>mysql_error() ) );
		die;
	}

	//date('Y-m-d' , $oldestDate)

?>
