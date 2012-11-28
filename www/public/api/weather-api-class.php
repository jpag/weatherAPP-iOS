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

	class worldweather{

		// SCRIBBLE API:
		protected $API_ENDPOINT = 'http://free.worldweatheronline.com/feed/weather.ashx';
		//example of added params: q=70.00,40.00&format=json&num_of_days=2&key=f37a11b8a4173144122111
		protected $ACCESS_TOKEN;

		//CONFIG SETTINGS
		protected $NUM_DAYS = '2'; //the min amount
		protected $FORMAT = 'json';
		protected $CACHE = true;
		protected $OVERRIDECACHE = false;
		protected $CACHEEXPIRES = '1 day';
		protected $CACHEFOLDER = 'cache/';

		public function __construct($config){
			
			if( isset($config['ACCESS_TOKEN'])){
				$this->ACCESS_TOKEN = $config['ACCESS_TOKEN'];
			}

			if( isset($config['FORMAT'])){
				$this->FORMAT = $config['FORMAT'];
			}

			if( isset($config['CACHE'])){
				$this->CACHE = $config['CACHE'];
			}

			if( isset($config['CACHEEXPIRES'])){
				$this->CACHEEXPIRES = $config['CACHEEXPIRES'];
			}

			if( isset($config['NUM_DAYS'])){
				$this->NUM_DAYS = $config['NUM_DAYS'];
			}

			if( isset($config['OVERRIDECACHE'])){
				$this->OVERRIDECACHE = $config['OVERRIDECACHE'];
			}
			
			if( isset($config['CACHEFOLDER'])){
				$this->CACHEFOLDER = $config['CACHEFOLDER'];
			}
		}

		public function queryGPS($LATLONG, $CITY){
			$GPS_TYPE = 'gps';
			
			//DO A CATCH HERE TO DETERMINE RANGE OF CITY?
			$CACHERESULT = $this->cacheChecker($GPS_TYPE, $CITY);
			
			if( $CACHERESULT == false ){
				//determine label - the filename of the cache
				if( isset($CITY) ){
					$LABEL = $CITY;
				}else{
					$LABEL = $LATLONG[0].'-'.$LATLONG[1];
				}

				/*
				// Query * request made to API
				// CacheQuery * caches the query made 
				*/

				$result = $this->cacheQuery(
												$GPS_TYPE, 
												$LABEL, 
												$this->CACHEEXPIRES, 
												$this->query(
																array( "q"=>$LATLONG[0].','.$LATLONG[1] ) 
															)
												);

				return $result;
			}else{
				return $CACHERESULT;
			}
		}

		protected function query($PARAMS){

			$PARAMSFORMATTED = '';
			
			if( isset( $PARAMS ) ){
				foreach ($PARAMS as $key => $value) {
					$PARAMSFORMATTED .= '&'.$key.'='.$value;
				}
			}
			
			$URL  = $this->API_ENDPOINT . '?key='.$this->ACCESS_TOKEN;
			$URL .= '&format='.$this->FORMAT;
			$URL .= '&num_of_days='.$this->NUM_DAYS;
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
		protected function cacheQuery($TYPE , $ID, $EXPIRES, $JSON_DECODED ){
			
			$ARRAY = json_decode($JSON_DECODED);
			$ARRAY->cacheDate = strtotime($EXPIRES);
			$JSON_TIMESTAMPED = json_encode($ARRAY);
			
			if( $this->CACHE == true ){
				$CACHEFILE = $this->generateCacheFileName($TYPE, $ID);
				$fh = fopen($CACHEFILE, 'w') or die(json_encode("error"));
				fwrite($fh, $JSON_TIMESTAMPED );
				fclose($fh);
			}

			return $JSON_TIMESTAMPED;
		}

		/*
		returns the cache or false if the cache has expired
		*/
		protected function cacheChecker( $TYPE , $ID){

			$CACHEFILE = $this->generateCacheFileName($TYPE, $ID);
			
			if( file_exists($CACHEFILE) && $this->OVERRIDECACHE == false ){
				$cachefileJSON = file_get_contents($CACHEFILE);
				$decodedCache = json_decode($cachefileJSON, true);

				//var_dump($decodedCache);
				//echo $decodedCache['cacheDate'] . ' vs ' . time('now');
			  	
			  	if( $decodedCache != null && 
			  		$decodedCache['cacheDate'] > time('now') ){	
			  		//echo ' cache '. time('now') ;

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

		protected function generateCacheFileName($TYPE , $ID ){
			return $this->CACHEFOLDER.$TYPE.'_'. $this->sanitize($ID) .'.json';
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


