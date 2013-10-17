<?php

	/* Connect to MySQL, and connect to the Database */
	//echo ' db connect ' . $DB_HOST. ' ' . $DB_USER . ' ' . $DB_PASS;
	
	mysql_connect( $DB_HOST, $DB_USER, $DB_PASS ) or die(mysql_error());
	mysql_select_db($DB_NAME) or die(mysql_error());
	
?>