var NavView = viewTemplate.create({
	templateName:"nav-template",
	classNames:["nav", "container"],
	config:null,
	


	init:function(){
		this.config = copy.nav;
		this._super();
	},

	didInsertElement:function(){
		NavView.$("#presentedBy").bind({
			"click":NavView.sponsorClicked
		});

		NavView.$("#masterHead-container").bind({
			"click":NavView.animateToTop
		});

		NavView.$("#headerReutersLogo").bind({
			"click":NavView.logoClicked
		});

	},

	animateToTop:function(e){
		$("html, body").animate({scrollTop:0})
	},

	sponsorClicked:function(e){
		gaTrackEvent('Sponsor Clicked' , 'nav'  );
		window.open(NavView.config.sponsorURL);
	},

	logoClicked:function(e){
		window.open(NavView.config.reutersHome );
	}

	//resize:function(obj){ }

});