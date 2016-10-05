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

	class forecast{

		//protected $API_ENDPOINT = 'https://api.forecast.io/forecast/';
		protected $API_ENDPOINT = 'https://api.darksky.net/forecast/';

		protected $ACCESS_TOKEN;

		//CONFIG SETTINGS
		protected $DEV_STATE = "live";

		protected $CACHE = true;
		protected $OVERRIDECACHE = false;
		protected $CACHEEXPIRES = '3 hours';
		protected $CACHEFOLDER = 'cache/';

		protected $PARAMS = array(''=>'');
		protected $TIME = '';
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

			if( isset($config['DEV_STATE'])){
				$this->DEV_STATE = $config['DEV_STATE'];
			}

			if( isset($config['PARAMS'])){
				$this->PARAMS = $config['PARAMS'];
			}

			if( isset($config['TIME'])){
				$this->TIME = $config['TIME'];
			}else{
				$this->TIME = time();
			}
			
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
				
				/*
				* Query * request made to API
				* CacheQuery * caches the query made 
				*/

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

			$TIMESTAMP = $this->TIME;
			$FROMTIME = $this->FROMTIME;

			$RESULTPAST = json_decode($this->query($LATLONG, $FROMTIME));
			$RESULT = json_decode($this->query($LATLONG));

			// echo json_encode($RESULT);
			// exit(1);

			if( $RESULTPAST && $RESULT ){

				//var_dump($RESULTPAST->currently->temperature);

				if( isset( $RESULTPAST->currently) && isset( $RESULT->currently) ){

					$PAST = $RESULTPAST->currently;
					$CURRENT = $RESULT->currently;

					$RESULTPAST_FORMATTED = new stdClass();
					$RESULT_FORMATTED = new stdClass();
					$RESULT_TOMORROW = new stdClass();

					$RESULTPAST_FORMATTED->temp = $this->convertTemp( $PAST->temperature );
					$RESULTPAST_FORMATTED->weathercode = $PAST->icon; 
					$RESULTPAST_FORMATTED->rain = $PAST->precipIntensity;
					$RESULTPAST_FORMATTED->rainchance = $PAST->precipProbability;
					$RESULTPAST_FORMATTED->summary = $PAST->summary;
					$RESULTPAST_FORMATTED->timestamp = $PAST->time;

					$RESULT_FORMATTED->temp = $this->convertTemp( $CURRENT->temperature );
					$RESULT_FORMATTED->weathercode = $CURRENT->icon;
					$RESULT_FORMATTED->rain = $CURRENT->precipIntensity;
					$RESULT_FORMATTED->rainchance = $CURRENT->precipProbability;
					$RESULT_FORMATTED->summary = $CURRENT->summary;
					$RESULT_FORMATTED->timestamp = $CURRENT->time;

					if( $this->DEV_STATE == 'dev' ){
						$RESULTPAST_FORMATTED->dev = $RESULTPAST;
						$RESULT_FORMATTED->dev = $RESULT;
					}

					if( isset($RESULT->hourly) ){
						// let us add the future:
						$tomorrowMin = strtotime("+23 hours");
						$tomorrowMax = strtotime("+25 hours");
						
						// print "today time " . $TIMESTAMP;
						// print " tomorrow - ". $tomorrowMin;
						// print " tomorrow one day one hour ". $tomorrowMax;

						if( isset($RESULT->hourly->data) ){
							$counter = 0;
							foreach($RESULT->hourly->data as &$hour) {
								$counter++;
								$dataTime = $hour->time;
								
								// print "\n\n " . $tomorrowMin . " < hour time: " . $dataTime . " < ". $tomorrowMax;
								// print "-----  \n";
								// var_dump($tomorrowMin < $dataTime);
								// print "----- and \n";
								// var_dump($dataTime < $tomorrowMax);

								if( ($tomorrowMin < $dataTime) && ($dataTime < $tomorrowMax) ){
									// print " found matching time point " . $hour->time;
									$TOMORROW = $hour;
									break;
								}
								// print " -- count ". $counter;
							}
							
							// exit(1);

							// $numOfHours = count($RESULT->hourly->data) - 1;
							// $TOMORROW = $RESULT->hourly->data[$numOfHours];

							$RESULT_TOMORROW->temp = $this->convertTemp( $TOMORROW->temperature );
							$RESULT_TOMORROW->weathercode = $TOMORROW->icon;
							$RESULT_TOMORROW->rain = $TOMORROW->precipIntensity;
							$RESULT_TOMORROW->rainchance = $TOMORROW->precipProbability;
							$RESULT_TOMORROW->summary = $TOMORROW->summary;
							$RESULT_TOMORROW->timestamp = $TOMORROW->time;
						}
					}

					$RESULTS = array( 
									'timecompared' => array(
															'past' => $RESULTPAST_FORMATTED, 
															'present' => $RESULT_FORMATTED,
															'tomorrow' => $RESULT_TOMORROW
														)
									);
				}else{
					$RESULTS = array(
								'error' => '101',
								'message' => 'Results no current found.'
							);
				}

			}else{
				$RESULTS = array(
								'error' => '100',
								'message' => 'Results Compared and/or Result do not exist, May be a faulty connection with the api'
							);
			};

			return json_encode( $RESULTS );
		}


		protected function convertTemp($temp){
			return $temp + 274.15;
		}

		protected function query($LATLONG, $TIME){

			$PARAMSFORMATTED = '?';
			
			if( isset( $this->PARAMS ) ){
				foreach ($this->PARAMS as $key => $value) {
					$PARAMSFORMATTED .= $key.'='.$value.'&';
				}
			}
			
			if( isset($TIME)){
				$URL  = $this->API_ENDPOINT . $this->ACCESS_TOKEN .'/'. $LATLONG[0].','.$LATLONG[1] .','. $TIME ;
			}else{
				$URL  = $this->API_ENDPOINT . $this->ACCESS_TOKEN .'/'. $LATLONG[0].','.$LATLONG[1];
			}
			
			$URL .= $PARAMSFORMATTED;
			
			$QUERY_CURL = curl_init( $URL );
			
			$CURL_OPTIONS = array(
		    	CURLOPT_CUSTOMREQUEST => "GET",
		    	CURLOPT_RETURNTRANSFER=>true
		    );

			curl_setopt_array($QUERY_CURL, $CURL_OPTIONS);
			$QUERY_RESULT = curl_exec( $QUERY_CURL ); 
			curl_close( $QUERY_CURL );

			return $QUERY_RESULT;
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


