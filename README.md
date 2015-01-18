Weather App
compares today's temperature to yesterdays


API:



all weather measured in C (and converted as needed)
	C to F
	37 + 40 = 77, and 77 * 9/5 = 138.6. For the final calculation, remove the 40. 138.6 - 40 = 98.6 
	http://www.csgnetwork.com/tempconvjava.html
	C to F
	(( C + 40 ) * 9/5 ) - 40 = F

	F to C
	98.6 + 40 = 138.6, and 138.6 * 5/9 = 77. For the final calculation, remove the 40. 77 - 40 = 37
	(( F + 40 ) * 5/9 ) - 40 = C


http://www.worldweatheronline.com/
API access key:
f37a11b8a4173144122111

http://worldweatheronline.com/feed-generater.aspx

http://worldweatheronline.com/free-weather-feed.aspx

	500 requests per hour (max)

	-request top 100 cities every morning before 6am EST.
	-find closest city if your city was not cached from yesterday.
	(via GPS/zipcode?)


// get GPS points via:
http://itouchmap.com/latlong.html


//GIT search for conflicts on merges with:
"<<<<<<< HEAD"

//servers:
connect via ssh:
pem : 
ec2s:
cloud:

SETUP with LESS and EmberJs


all API calls should return a 'type' value for the IOS app to understand what type of data it is getting back 
	type = cities (city list)
	type= temps (temperatures)


--------------------
---- IOS ref links:
--------------------
basics:
http://cocoadevcentral.com/d/learn_objectivec/

CORE DATE / STORAGE:
http://stackoverflow.com/questions/9421271/ios-core-data-class-method
http://nachbaur.com/blog/smarter-core-data
http://stackoverflow.com/questions/10088274/using-core-data-with-an-existing-single-view-application
http://www.raywenderlich.com/934/core-data-on-ios-5-tutorial-getting-started
http://timroadley.com/2012/02/09/core-data-basics-part-1-storyboards-delegation/
http://maniacdev.com/2012/03/tutorial-getting-started-with-core-data-in-ios-5-using-xcode-storyboards/


SINGLETONS:
http://klanguedoc.hubpages.com/hub/iOS-5-How-To-Share-Data-Between-View-Controllers-using-a-Singleton
http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
http://stackoverflow.com/questions/6335767/core-data-singleton-manager

DELEGATES / PROTOCOL
delegate for a singleton object http://stackoverflow.com/questions/9475469/delegate-for-a-singleton-object
singleton class in objective c http://stackoverflow.com/questions/7130128/singleton-class-in-objective-c
http://developer.apple.com/library/ios/#featuredarticles/ViewControllerPGforiPhoneOS/ManagingDataFlowBetweenViewControllers/ManagingDataFlowBetweenViewControllers.html#//apple_ref/doc/uid/TP40007457-CH8-SW9
http://mobile.tutsplus.com/tutorials/iphone/ios-sdk-custom-delegates/
Simple delegate tutorial for ios development - http://www.roostersoftstudios.com/2011/04/12/simple-delegate-tutorial-for-ios-development/
http://stackoverflow.com/questions/5210535/passing-data-between-view-controllers


POINTERS:
http://stackoverflow.com/questions/5293406/another-warning-question-incompatible-integer-to-pointer-conversion-assigning

http://www.daveoncode.com/2011/12/19/fundamental-ios-design-patterns-sharedinstance-singleton-objective-c/
http://www.cimgf.com/2011/01/07/passing-around-a-nsmanagedobjectcontext-on-the-iphone/
http://oleb.net/blog/2011/11/working-with-date-and-time-in-cocoa-part-1/

http://useyourloaf.com/blog/2011/02/08/understanding-your-objective-c-self.html

JSON:
http://agilewarrior.wordpress.com/2012/02/01/how-to-make-http-request-from-iphone-and-parse-json-result/
http://www.raywenderlich.com/5492/working-with-json-in-ios-5


/////// MATH LONG / GPS

http://stackoverflow.com/questions/11510326/how-do-i-check-if-a-longitude-latitude-point-is-within-a-range-of-coordinates/11510666



