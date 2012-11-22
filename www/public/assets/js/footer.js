var FooterView = viewTemplate.create({
	templateName:"footer-template",
	classNames:["footer", "container"],
	config:null,

	init:function(){
		this.config = copy.footer
		this._super();
	},

	didInsertElement:function(){
		this._super();
	},
	
	resize:function(obj){
		if( FooterView.addedToStage == false ){	
			Debug.trace( '  FOOTER VIEW NOT ADDED TO STAGE YET ' );
			return false;
		}
		return true;
	}
});
