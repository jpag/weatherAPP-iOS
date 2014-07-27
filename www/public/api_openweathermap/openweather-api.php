<?php
	
	/*
	WARNING
	THIS DOES NOT TAKE INTO ACCOUNT YET
	IF A USER HAS BEEN ONLINE FOR OVER 2 HOURS 
	*/
	
	if (!function_exists('curl_init')) {
  		throw new Exception('-needs the CURL PHP extension.');
	}
	if (!function_exists('json_decode')) {
	  	throw new Exception('-needs the JSON PHP extension.');
	}

	class openWeather{

		//http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139
		protected $API_ENDPOINT = 'http://api.openweathermap.org/data/2.5/';
		protected $ACCESS_TOKEN;

		//CONFIG SETTINGS
		
		protected $CACHE = true;
		protected $OVERRIDECACHE = false;
		protected $CACHEEXPIRES = '3 hours';
		protected $CACHEFOLDER = 'cache/';
		
		protected $NUMSTATIONS = 2;

		protected $PARAMS = array(''=>'');
		//protected $TIME = '';
		protected $FROMTIME = '';

		public function __construct($config){
			
			if( isset($config['ACCESS_TOKEN'])){
				$this->ACCESS_TOKEN = $config['ACCESS_TOKEN'];
			}

			if( isset($config['CACHE'])){
				$this->CACHE = $config['CACHE'];
			}

			if( isset($config['CACHEEXPIRES'])){
				$this->CACHEEXPIRES = $config['CACHEEXPIRES'];
			}

			if( isset($config['OVERRIDECACHE'])){
				$this->OVERRIDECACHE = $config['OVERRIDECACHE'];
			}
			
			if( isset($config['CACHEFOLDER'])){
				$this->CACHEFOLDER = $config['CACHEFOLDER'];
			}

			if( isset($config['PARAMS'])){
				$this->PARAMS = $config['PARAMS'];
			}

			// if( isset($config['TIME'])){
			// 	$this->TIME = $config['TIME'];
			// }else{
			// 	$this->TIME = time();
			// }
			
			if( isset($config['FROMTIME'])){
				$this->FROMTIME = $config['FROMTIME'];
			}else{
				$this->FROMTIME = strtotime('-1 day');
			}

		}

		
		public function queryGPS($LATLONG){
			//DO A CATCH HERE TO DETERMINE RANGE OF CITY?
			$CACHERESULT = $this->cacheChecker($LATLONG);
			
			if( $CACHERESULT == false ){
				
				$result = $this->cacheQuery(
												$LATLONG, 
												$this->CACHEEXPIRES, 
												$this->queryBothTimes($LATLONG)
							);

				return $result;
			}else{
				return $CACHERESULT;
			}
		}
		
		// All queries are made via lat long :
		protected function queryBothTimes($LATLONG){
			$RESULT = $this->querystation($LATLONG);

			//var_dump($RESULT);
			//die;	
			if( is_object($RESULT) ){
				// find ID in result:
				$STATIONID = $RESULT->list[0]->station->id;
				$RESULTPAST = $this->queryPast($STATIONID,$LATLONG);
			}

			if( isset($RESULTPAST) && isset($RESULT) ){

				$RESULTS = array( 
								'timecompared' => array(
														'past' => $RESULTPAST, 
														'present' => $RESULT 
													)
							);
			}else{
				$RESULTS = array(
								'error' => '100',
								'message' => 'Results Compared and/or Result do not exist, May be a faulty connection with the api'
							);
			};

			return json_encode( $RESULTS );
		}

		protected function querystation($LATLONG){

			$PARAMS = $this->PARAMS;
			$PARAMS["lat"] = $LATLONG[0];
			$PARAMS["lon"] = $LATLONG[1];
			// return number of stations:
			$PARAMS["cnt"] = $this->NUMSTATIONS;
			
			$queryreturn = $this->query('station/find', $PARAMS);
			if( is_array($queryreturn) && count($queryreturn) > 1 ){

				$result = new stdClass();


				$result->list = array(
				 					$this->reformatStationData($queryreturn[0]),
				 					$this->reformatStationData($queryreturn[1]) 
				 				);

				$result->temp = $queryreturn[0]->last->main->temp;
				$result->URL = $queryreturn['URL'];
			}
			return $result;
		}

		protected function reformatStationData($station){
			// take what is out of the last val.. 
			// remove it and make it main. to match the history values;

			$newstation = $station->last;
			$newstation->station = $station->station;
			$newstation->distance = $station->distance;
			
			return $newstation;
		}

		protected function queryPast($STATIONID, $LATLONG){
			$PARAMS = $this->PARAMS;
			$PARAMS["lat"] = $LATLONG[0];
			$PARAMS["lon"] = $LATLONG[1];
			$PARAMS["id"] = $STATIONID;
			$PARAMS["type"] = "hour";
			$PARAMS["start"] = $this->FROMTIME;

			//$PARAMS["start"] = $FROMTIME;
			//$PARAMS["end"] = $TIMESTAMP;

			$queryreturn = $this->query('history/station', $PARAMS);

			if( is_object($queryreturn) ){
				$list = $queryreturn->list;
				$result = new stdClass();

				// $list[0]->main->temp = $list[0]->main->temp->v;
				// $list[1]->main->temp = $list[1]->main->temp->v;
				//$result->list = [ $list[0], $list[1] ];
				$result->temp = $list[0]->main->temp->v;
				$result->URL = $queryreturn->URL;
			}

			return $result;
		}

		protected function query($TYPE, $PARAMS){

			$PARAMSFORMATTED = '?';
			

			$PARAMS["APPID"] = $this->ACCESS_TOKEN;
			if( isset( $PARAMS ) ){
				foreach ($PARAMS as $key => $value) {
					$PARAMSFORMATTED .= $key.'='.$value.'&';
				}
			}

			// http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&APPID=accesstoken
			// http://api.openweathermap.org/data/2.5/history/station?id=2121?units=metric&type=hour

			$URL  = $this->API_ENDPOINT . $TYPE;
			$URL .= $PARAMSFORMATTED;
			
			$QUERY_CURL = curl_init( $URL );
			
			$CURL_OPTIONS = array(
		    	CURLOPT_CUSTOMREQUEST => "GET",
		    	CURLOPT_RETURNTRANSFER=>true
		    );

			curl_setopt_array($QUERY_CURL, $CURL_OPTIONS);
			$QUERY_RESULT = curl_exec( $QUERY_CURL ); 
			curl_close( $QUERY_CURL );


			//echo $QUERY_RESULT;
			//die;
			$DECODED = json_decode( $QUERY_RESULT );
			
			if( $GLOBALS['STATE'] == 'dev' ){
				if( !isset($DECODED )){
					$DECODED = new stdClass();	
				}

				if( is_array($DECODED) ){
					$DECODED["URL"] = $URL;
				}else{
					$DECODED->URL = $URL;
				}
			}

			return $DECODED;
			
		}

		/*
		// takes a new query and caches the result
		*/
		protected function cacheQuery($LATLONG, $EXPIRES, $JSON_DECODED ){
			
			$ARRAY = json_decode($JSON_DECODED);
			$ARRAY->cacheDate = strtotime($EXPIRES);
			$JSON_TIMESTAMPED = json_encode($ARRAY);
			
			if( isset($ARRAY->error) ){
				// Do not cache if there was an error in the JSON request.
			}else if( $this->CACHE == true ){
				$CACHEFILE = $this->generateCacheFileName($LATLONG);
				$fh = fopen($CACHEFILE, 'w') or die(json_encode("error"));
				fwrite($fh, $JSON_TIMESTAMPED );
				fclose($fh);
			}

			return $JSON_TIMESTAMPED;
		}

		/*
		returns the cache or false if the cache has expired
		*/
		protected function cacheChecker( $LATLONG ){
			
			$CACHEFILE = $this->generateCacheFileName($LATLONG);
			
			if( file_exists($CACHEFILE) && $this->OVERRIDECACHE == false ){
				$cachefileJSON = file_get_contents($CACHEFILE);
				$decodedCache = json_decode($cachefileJSON, true);

				//var_dump($decodedCache);
				//echo $decodedCache['cacheDate'] . ' vs ' . time('now');
			  	
			  	if( $decodedCache != null && 
			  		$decodedCache['cacheDate'] > time('now') ){	
			  		
			  		//echo ' cache file '. time('now') ;

			  		return $cachefileJSON;
			  	}else{
			  		//out of date
			  		return false;
			  	}
			}else{
				// override cache or file does not exist:
				return false;
			}
		}

		protected function generateCacheFileName($LATLONG ){
			return $this->CACHEFOLDER.$LATLONG[0].'_'.$LATLONG[1].'.json';
		}

		/**
		* Function: sanitize
		* Returns a sanitized string, typically for URLs.
		*
		* Parameters:
		*     $string - The string to sanitize.
		*     $force_lowercase - Force the string to lowercase?
		*     $anal - If set to *true*, will remove all non-alphanumeric characters.
		*/
		public function sanitize($string) {
			return strtolower( preg_replace(array('/\s/', '/\.[\.]+/', '/[^\w_\.\-]/'), array('_', '.', ''), $string ) );
		}

	}/* END CLASS */
?>


