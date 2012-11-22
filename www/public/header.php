<!doctype html>
<!-- <?php echo $_SERVER['HTTP_HOST'] ?> -->
<!--[if lt IE 7 ]> 
  <html lang="en" class="<?php echo $layout; ?> ie ie6"> 
<![endif]--> 
<!--[if IE 7 ]> 
  <html lang="en" class="<?php echo $layout; ?> ie ie7">
<![endif]--> 
<!--[if IE 8 ]>    
  <html lang="en" class="<?php echo $layout; ?> ie ie8"> 
<![endif]--> 
<!--[if IE 9 ]>    
  <html lang="en" class="<?php echo $layout; ?> ie ie9"> 
<![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> 
  <html lang="en" class="<?php echo $layout; ?>" > 
<!--<![endif]-->
<head>
  
  <?php 
  //<!-- Ensighten integration, according to the documentation this needs to remain in the head --> 
  //<script type="text/javascript" src="//nexus.ensighten.com/reuters/Bootstrap.js"></script>  
  ?>

  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title><?php echo $TITLE; ?></title>
  <meta name="description" content="<?php echo $DESCRIPTION; ?>">
  <meta name="author" content="Reuters">
  <meta name="keywords" content="<?php echo $METATAGS; ?>" />
  
  <?php if( $layout != 'desktop'):?>
  <meta name="viewport" content="width=device-width; maximum-scale=1.0;">
  <?php endif; ?>

  <link rel="shortcut icon" href="assets/images/icons/favicon.ico">

  <link rel="stylesheet" href="<?php echo $GLOBALASSETSPATH; ?>assets/css/ui-lightness/jquery-ui-1.9.0.custom.min.css" >
  
  <link rel="stylesheet" href="<?php echo $GLOBALASSETSPATH; ?>assets/css/global.css">
  <!-- deals with any conflicts of fonts not being pulled from different domain: -->
  <link rel="stylesheet" href="/assets/css/font.css">


  <meta property="fb:app_id" content="294699217304800"/>
  <meta property="og:url" content="http://innovations.reuters.com" />
  <meta property="og:title" content="<?php echo $TITLE; ?>"/>
  <meta property="og:type" content="Article"/>
  <meta property="og:image" content="http://innovations.reuters.com/assets/images/share/site-screen-200x200.jpg" />
  <meta property="og:site_name" content="<?php echo $TITLE; ?>"/>
  <meta property="og:description" content="<?php echo $DESCRIPTION; ?>"/>
  
  <!--[if lt IE 9]>
  <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
</head>