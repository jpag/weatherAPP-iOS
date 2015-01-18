<?php
	require_once('config.php');
	require_once('header.php');
?>
<body>
  <div id="fb-root"></div>

  <div id="siteloader"
    style="position:relative;margin:auto;margin-top:20%;width:32px" >
    <img src="<?php echo $GLOBALASSETSPATH; ?>assets/images/ui/loading-75x75.gif" width="75" height="75" />
  </div>

<!-- templates -->
  <?php
  	require_once('templates/footer.html');
  	require_once('templates/feature.html');
  	require_once('templates/nav.html');
  ?>

<!-- scripts -->
<script type="text/javascript" src="<?php echo $GLOBALASSETSPATH; ?>assets/js/lib/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="<?php echo $GLOBALASSETSPATH; ?>assets/js/lib/jquery.mousewheel.min.js"></script>
<script type="text/javascript" src="<?php echo $GLOBALASSETSPATH; ?>assets/js/lib/jquery.easing.1.3.min.js"></script>
<script type="text/javascript" src="<?php echo $GLOBALASSETSPATH; ?>assets/js/lib/jqueryui/jquery-ui-1.9.0.custom.min.js" ></script>

<script type="text/javascript" src="<?php echo $GLOBALASSETSPATH; ?>assets/js/lib/handlebars-1.0.0.beta.6.js"></script>
<script type="text/javascript" src="<?php echo $GLOBALASSETSPATH; ?>assets/js/lib/ember-1.0.pre.min.js"></script>

<script type="text/javascript" src="<?php echo $GLOBALASSETSPATH; ?>assets/js/lib/jquery.scroll-startstop.events.js"></script>
<script type="text/javascript" src="<?php echo $GLOBALASSETSPATH; ?>assets/js/lib/modernizr.custom.62463.js"></script>


<?php if( $LIVE == false ): ?>
<script type="text/javascript" src="<?php echo $GLOBALASSETSPATH; ?>assets/js/debugger.js"></script>
<?php endif; ?>

<script type="text/javascript" >
//universal template used,
//adds some additional features needed on all views
var elementsAdded = 0;
var firstTime = true;
var viewTemplate = Em.View.extend({
	addedToStage:false,

	didInsertElement:function(){
		this.addedToStage = true;
		elementsAdded++;
		resizeAll();
	}
});

  //'GLOBAL' scope/setup
  	var global = new function(){
		return {

				<?php if( $LIVE == false ): ?>
				//root folder of the overall site
				//add trailing '/' i.e. http://www.example.com/
				root:"",

				//CDN hosting and a revision number
				version:"0",
				//used only if it is NOT ""
				//for hosting static files on a different server.
				//add trailing '/' i.e. http://cdn.example.com/assets/
				_assetsroot:"",

				//http://live-convention-files.s3.amazonaws.com",
				//d2trzn7fckv2gf.cloudfront.net

				<?php else: ?>
				root:"",
				version:"<?php echo $ASSETS; ?>",
				_assetsroot:"<?php echo $CLOUDURL; ?>",
				<?php endif; ?>


				assets:function(){
					var path = global.root;
					if( global._assetsroot != '' ){ path = global._assetsroot };
					if( global.version > 0 ){ path += "/"+global.version+'/' };
					path += "assets/";
					return path;
				},

				//FACEBOOK INFO:
				fb:{
					appid:""
				},

				browserType:"<?php echo $layout; ?>",
				minWidth:970,
				minHeight:600,

				insertScripts:[
					//{name: "lib/d3.v2" , deps:Modernizr.svg },
					{name: "copy", deps:true },
					{name: "feature", deps:true},
					{name: "footer", deps:true},
					{name: "nav", deps:true},
					{name: "app", deps:true}
				],

				init:function(){
					var appendScriptName = '';
					if( !window.Debug || (global.getIE() != -1) ){
						appendScriptName = '.min';
						//NOT IN DEBUG MODE if it is IE 'Debug' is a component of IE
						//define a blank function to handle all traces:
						window.Debug = new function(){return{trace:function(str){}}};
					}else{
						Debug.init();
					};
					//loop through and find all the scripts
					//to write into the document.
					var s;
					for(var s=0; s< global.insertScripts.length ; s++ ){
						if( global.insertScripts[s].deps == true ){
							var sjs = '<script src="'+global.assets()+'js/'+global.insertScripts[s].name+appendScriptName+'.js"><\/script>';
							document.write( sjs );
						}
					};
				},

                  // http://msdn.microsoft.com/en-us/library/ms537509(v=vs.85).aspx
                  getIE: function()
                  // Returns the version of Internet Explorer or a -1
                  // (indicating the use of another browser).
                  {
                    var rv = -1; // Return value assumes failure.
                    if (navigator.appName == 'Microsoft Internet Explorer')
                    {
                      var ua = navigator.userAgent;
                      var re  = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
                      if (re.exec(ua) != null)
                        rv = parseFloat( RegExp.$1 );
                    }
                    return rv;
                  },

                  parseYoutubeDate: function(str_time){
			          //will come in like: "2012-08-04T00:30:01.000Z":
			          var dateObj = new Date(Date.parse(str_time));
			          var date = {
			            year        : dateObj.getFullYear(),
			            month       : dateObj.getMonth()+1,
			            day         : dateObj.getDate()
			          };
			          var months = ["January","Feburary","March","April","May","June","July","August","September","October","November","December"];

			          date.milliseconds = Date.UTC(date.year, date.month, date.day);

			          return {
			                    year:date.year,
			                    month:date.month,
			                    day:date.day,
			                    milliseconds:date.milliseconds,
			                    readableMonth:months[dateObj.getMonth()],
			                    jsdate: new Date( str_time )
			                  };
			        },

			        insertCommasInNumber:function(str) {
 						return (str + "").replace(/\b(\d+)((\.\d+)*)\b/g, function(a, b, c) {
    						return (b.charAt(0) > 0 && !(c || ".").lastIndexOf(".") ? b.replace(/(\d)(?=(\d{3})+$)/g, "$1,") : b) + c;
  						});
					}

			}//end return
        }//end global

	global.init();
</script>

<!-- google analytics -->
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-34312326-2']);
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

  function gaTrackEvent(category , action , label ){
  	label = (typeof label === "undefined") ? "" : label.toString();
  	category = category.toString();
  	action = action.toString();
    _gaq.push(['_trackEvent', category, action, label ])

  }
  function gaTrackPage(page){
    _gaq.push(['_trackPageview', page ]);
  }
</script>

<!-- facebook like script -->
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=294699217304800";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
</script>

<!-- TWITTER SCRIPT -->
<script>
!function(d,s,id){
var js,fjs=d.getElementsByTagName(s)[0];
if(!d.getElementById(id)){
js=d.createElement(s);
js.id=id;js.src="https://platform.twitter.com/widgets.js";
fjs.parentNode.insertBefore(js,fjs);
}
}(document,"script","twitter-wjs");
</script>

<!-- google +1 btn -->
<!-- Place this tag in your head or just before your close body tag. -->
<script type="text/javascript" src="https://apis.google.com/js/plusone.js">
  {parsetags: 'explicit'}
</script>


<!-- linkedin -->
<script src="//platform.linkedin.com/in.js" type="text/javascript"></script>

<?php require_once 'version.php' ?>

</body>
</html>