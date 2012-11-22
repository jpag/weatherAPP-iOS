/**
 * https://github.com/danharper/Handlebars-Helpers
 * If Equals
 * if_eq this compare=that
 */
/*
Handlebars.registerHelper('if_eq', function(context, options) {

	Debug.trace(context +' vs ' + options.hash.compare );

	if (context == options.hash.compare){
		Debug.trace(' match');
		return options.fn(this);
	}else{
		return options.inverse(this);
	}
});
*/


var FeatureView = viewTemplate.create({
	templateName:"feature-template",
	classNames:["features", "container"],
	config:null,

	reports:[],
	//attributeBindings:["reports"],
	columnsAvail:['B','C','D','E'],

	init:function(){
		this.config = copy.feature
		this._super();
	},

	didInsertElement:function(){
		//this._super();
		this.loadReports();
    	
		/*
		FeatureView.$("#bucket-ad-space").bind({
			"click":FeatureView.AdClicked
		})
		*/


		/*
		Ember.run.later(FeatureView, function(){
			FeatureView.loadAdUnit();
		}, 5000 );
		*/

		FeatureView.addedToStage = true;
		resizeAll();
	},

	AdClicked:function(e){
		window.open(FeatureView.config.sponsorURL);
	},

	loadReports:function(){
		var url = FeatureView.config.feed;
		$.getJSON( url , FeatureView.reportsLoaded );
	},

  loadAdUnit: function() {
    // var adUnit = $('<iframe/>', {
    //   width: 500,
    //   height: 600,
    //   scrolling: 'no',
    //   src: this.config.adUnitURL
    // }).appendTo(FeatureView.$("#bucket-ad-space"));
	
	//var adUnitJs =  '<script src="http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=rsb&c=28&pli=5376167&PluID=0&w=300&h=600&ord=%n&ucm=true&ncu=$$%c$$"></script>';
	//	adUnitJs += '<noscript><a href="http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=brd&FlightID=5376167&Page=&PluID=0&Pos=1551" target="_blank"><img src="http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=bsr&FlightID=5376167&Page=&PluID=0&Pos=1551" border=0 width=300 height=600></a></noscript>';

	//var adUnitJs = '<div style="float:right"><script src="http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=rsb&c=28&pli=5376167&PluID=0&w=300&h=600&ord=%n&ucm=true&ncu=$$%c$$"><\/script><noscript><a href="http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=brd&FlightID=5376167&Page=&PluID=0&Pos=1551" target="_blank"><img src="http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=bsr&FlightID=5376167&Page=&PluID=0&Pos=1551" border=0 width=300 height=600><\/a><\/noscript><\/div>'
	//document write jquery will prevent this...
	//var adBucket = document.getElementById("bucket-ad-space")
	//adBucket.innerHTML = adUnitJs;
	//Debug.trace( adBucket );

	FeatureView.$("#bucket-ad-space").append( $("#eyeDiv") );
	FeatureView.$("#bucket-ad-space").append( $("#ad300x600") );

	FeatureView.$("#ad300x600").css({
		"display":"block"
	})


  },

	reportsLoaded:function(data){
		//Debug.trace(data);
		var articlesTemp = [
						{
							title:'',
							author:null,
							description:'',
							thumbnail:'',
							link:'',
							priority:999,
							column:'Z',
              				publish:'false'
						},
						{
							title:'',
							author:null,
							description:'',
							thumbnail:'',
							link:'',
							priority:999,
							column:'Z',
              				publish:'false'
						},
						{
							title:'',
							author:null,
							description:'',
							thumbnail:'',
							link:'',
							priority:999,
							column:'Z',
              				publish:'false'
						},
						{
							title:'',
							author:null,
							description:'',
							thumbnail:'',
							link:'',
							priority:999,
							column:'Z',
              				publish:'false'
						}
						];

		var columnsAvail = FeatureView.columnsAvail;
		for( var i = 0; i < data.feed.entry.length;i++ ){
            var cell = data.feed.entry[i];
            for(var columns=0; columns < columnsAvail.length; columns++){
            	if( cell.title.$t == columnsAvail[columns]+'2' ){
            		articlesTemp[columns].title = cell.content.$t;
            	}else if ( cell.title.$t == columnsAvail[columns]+'3' ) {
            		if( cell.content.$t.length > 1 ){
            			articlesTemp[columns].author = cell.content.$t;
            		}
            	}else if ( cell.title.$t == columnsAvail[columns]+'4' ) {
            		articlesTemp[columns].description = cell.content.$t;
            	}else if( cell.title.$t == columnsAvail[columns]+'5' ){
            		articlesTemp[columns].thumbnail = cell.content.$t;
            	}else if( cell.title.$t == columnsAvail[columns]+'6' ){
            		articlesTemp[columns].link = cell.content.$t;
            	}else if( cell.title.$t == columnsAvail[columns]+'7'){
            		if(Number(cell.content.$t) == 0 ){
            			//likely a space in string value converted to 0
            		}else{
            			articlesTemp[columns].priority = parseInt( cell.content.$t );
            		}
				}else if( cell.title.$t == columnsAvail[columns]+'8' ){
            		articlesTemp[columns].publish = cell.content.$t;
            	}

            	articlesTemp[columns].column = columnsAvail[columns];
            }
          }

          //insert only those articles that are complete:
          var fullArticles = new Array();
          for( var r=0; r < articlesTemp.length; r++ ){
          	var title = articlesTemp[r].title;
          	var description = articlesTemp[r].description;
          	var thumbnail = articlesTemp[r].thumbnail;
          	var link = articlesTemp[r].link;
          	var publish = articlesTemp[r].publish;

          	if( title.length > 3 &&
          		description.length > 3 &&
          		link.length > 5
          	){
          		if( publish.toLowerCase() == "true"   ||
                    publish.toLowerCase() == "t"    ||
                    publish.toLowerCase() == "yes"  ||
                    publish.toLowerCase() == "y"    ||
                    publish == "1"
          		){
                  fullArticles.push(articlesTemp[r]);
                }
          	}
          }

          fullArticles.sort(function(a,b){return a.priority-b.priority});

          //Debug.trace( fullArticles );
          FeatureView.reports = fullArticles;
          FeatureView.createBucket(fullArticles);
	},

	createBucket:function(ar){
		if(ar.length == 1 ){
			FeatureView.bucketView = singleBucket.create({report:ar[0]});
		}else if( ar.length == 2 ){
			FeatureView.bucketView = twoBucket.create({reports:ar});
		}else if( ar.length == 3){
			FeatureView.bucketView = threeBucket.create({reports:ar});
		}else if( ar.length == 4 ){
			FeatureView.bucketView = fourBucket.create({reports:ar});
		}
		FeatureView.bucketView.appendTo( FeatureView.$(".container") );
	},

	resize:function(obj){
		//Debug.trace( ' feature view stage ... ');
		if( FeatureView.addedToStage == false ){
			//Debug.trace( '  FEATURE VIEW NOT ADDED TO STAGE YET ' );
			return false;
		}

		// var h = Math.round( obj.h-($("#nav").height() + 50 ) );
  		//if( h < global.minHeight ){ h = global.minHeight };

		FeatureView.$().css({
		"width":obj.w
		//, "height":h
		})

		
		// $('#ad300x600').css({
		// 	left:(obj.w - global.minWidth)/2
		// });

		return true;
	}
});

var viewBucket = Em.View.extend({
	config:null,
	classNames:'bucket-container',
	init:function(){
		this._super();
	},
	resize:function(obj){

	}
})

var singleBucket = viewBucket.extend({
	templateName:"single-bucket-template"
});

var twoBucket = viewBucket.extend({
	templateName:"two-bucket-template"
});

var threeBucket = viewBucket.extend({
	templateName:"three-bucket-template"
});
var fourBucket = viewBucket.extend({
	templateName:"four-bucket-template"
});
