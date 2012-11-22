$(document).ready(
	function(){

		$("#siteloader").remove();

		NavView.append();
		SpecialGame.append();
		FeatureView.append();
		//SpecialView.append();
		StreamView.append();
		FooterView.append();

		$(window).resize(resizeAll);
		$(window).bind({
			'scroll': scrollEvents,
      'touchmove' : scrollEvents,
			'scrollstop': scrollStopEvents,
			'mousewheel': function() {
				$('html, body').stop();
			}
		})

		if( Modernizr.csstransforms3d == false ){
			$('body').addClass("no-csstransforms3d");
		} else{
			$('body').addClass("csstransforms3d");
		}
		if( Modernizr.csstransforms == false ){
			$('body').addClass('no-csstransforms');
		}

	}
);

function resizeAll(){

	 var obj = {
			      w:($(window).width() < global.minWidth )? global.minWidth : $(window).width(),
			      h: $(window).height()
			    };

	FeatureView.resize(obj);
	//FooterView.resize(obj);

	if( elementsAdded == 4 && firstTime == true ){
		firstTime = false;
		//Debug.trace(' SCROLLTOP ON START: special view: '+ SpecialView.$().height() + ' - window: ' + $(window).height() );
		/*
		$("html,body").animate({
			"scrollTop" : SpecialView.$().height()
		},{
			duration:50
		});
		*/
	}
}

function scrollEvents(ev) {
	//dispatch scrollEVENT to views
}

function scrollStopEvents() {
	//dispatch scrollEVENT STOP to views	
}

//check for css support:
var supports = (function() {
   var div = document.createElement('div'),
      vendors = 'Khtml Ms O Moz Webkit'.split(' '),
      len = vendors.length;
   return function(prop) {
      if ( prop in div.style ) return true;
      prop = prop.replace(/^[a-z]/, function(val) {
         return val.toUpperCase();
      });
      while(len--) {
         if ( vendors[len] + prop in div.style ) {
            // browser supports box-shadow. Do what you need.
            // Or use a bang (!) to test if the browser doesn't.
            return true;
         }
      }
      return false;
   };
})();

