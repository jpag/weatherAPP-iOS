var Debug = new function(){

	var d = null;

	return {

		init:function(){
			//is this needed?
			d = this;

			
			//DISABLE THE DEFAULT GLOBAL.CSS stylesheet (the first one)	
			//document.styleSheets[0].disabled = true;

			//PREVENT local storage from caching the css less scripts
			sessionStorage.clear();
			localStorage.clear();

			//var ljs = '<script> /* Provisory for dev environment: */ localStorage.clear(); </script>';
			//document.write(ljs);

			//ADD THE LESS COMPILER AND LESS FILES.
			//var sjs = '<script src="'+global.assets()+'js/lib/less-1.3.0.min.js"><\/script>';
            //document.write(sjs);

           //jquery version:
           //var linkrel = '<link rel="stylesheet/less" type="text/css" href="'+global.assets()+'css/global.less">'
           //$('head').append(linkrel);
           //console.log( document.getElementsByTagName('head') );
          
          /* 
           var 	linkNode = document.createElement('link')
           		linkNode.setAttribute('rel', 'stylesheet/less');
           		linkNode.setAttribute('type', 'text/css');
           		linkNode.setAttribute('href', global.assets()+'css/global.less');
           //console.log(' ADDING GLOBAL LESS ' );
           var 	head = document.getElementsByTagName('head')[0];
           		head.appendChild(linkNode);
          */

		},

		trace:function(str){
			try{					
				console.log( str );
			}catch(err){
				//error catch
			}
		}

	}
}

