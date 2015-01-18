<?php

$livedomainName = 'subdom.reuters.com';
$prodDomainName = 'subdom.reutersmagazine.com';
$CLOUDURL_NUM = '22';
$CLOUDURL_SERVER = 'http://d1evqy4lmcryat.cloudfront.net';

$TITLE = 'site title';
$DESCRIPTION = 'site description';
$METATAGS = 'News, Reuters';


if( $_SERVER['HTTP_HOST'] != $livedomainName && strpos( $_SERVER['HTTP_HOST'] , 'amazonaws.com') == false ){

  $LIVE = false;

  if( isset($_REQUEST['live']) ){
    $LIVE = true;
  }
}else{
  $LIVE = true;
}

if( $LIVE == true ){
  //once run with the cloudfront the files are cached for a min of 24hours.
  $CLOUDURL = $CLOUDURL_SERVER;
  $ASSETS = $CLOUDURL_NUM;
  $GLOBALASSETSPATH = $CLOUDURL.'/'.$ASSETS.'/';
}else{
  $CLOUDURL = "";
  $ASSETS = "";
  $GLOBALASSETSPATH = '';
}

require_once 'Mobile_Detect.php';
$detect = new Mobile_Detect();
$layout = ($detect->isMobile() ? ($detect->isTablet() ? 'tablet' : 'mobile') : 'desktop');




if( $_SERVER['HTTP_HOST'] ==  $prodDomainName ){
  $LIVE = true;
  //prevent debugger from added.
}

?>