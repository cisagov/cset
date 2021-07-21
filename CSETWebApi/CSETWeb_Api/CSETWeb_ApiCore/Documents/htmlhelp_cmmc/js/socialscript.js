
	
	var DREXPLAIN_SOCIALSCRIPT =  [	 ];
		 /*
			"//apis.google.com/js/plusone.js"
			,"//platform.twitter.com/widgets.js"
			,"//connect.facebook.net/en_US/all.js#xfbml=1"
			,'http://' + disqus_shortname + '.disqus.com/embed.js'
			,"//assets.pinterest.com/js/pinit.js"
			,"https://platform.stumbleupon.com/1/widgets.js"
			,"https://platform.linkedin.com/in.js"
			,,"http://delicious-button.googlecode.com/files/jquery.delicious-button-1.1.min.js"
		*/
		

	(function (w, d, load) {
		 var script, 
		 first = d.getElementsByTagName('SCRIPT')[0],  
		 n = load.length, 
		 i = 0,
		 go = function () {
		   for (i = 0; i < n; i = i + 1) {
			 script = d.createElement('SCRIPT');
			 script.type = 'text/javascript';
			 script.async = true;
			 script.src = load[i];
			 first.parentNode.insertBefore(script, first);
		   }
		 }
		 if (w.attachEvent) {
		   w.attachEvent('onload', go);
		 } else {
		   w.addEventListener('load', go, false);
		 }
		}(window, document, DREXPLAIN_SOCIALSCRIPT)
	);
