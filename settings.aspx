<!DOCTYPE html>
<html>
  	<head>
  	<title>CCV Command Center</title>
  
    	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no;" />
		<meta charset="utf-8">

		<link href="jquery-mobile/jquery.mobile-1.1.0.min.css" rel="stylesheet" type="text/css"/>
		<link href="jquery-mobile/ccv-mobile-bw.css" rel="stylesheet" type="text/css"/>
		<link href="css/mobile.css" rel="stylesheet" type="text/css"/>
		<link href="css/font-awesome.css" rel="stylesheet" type="text/css"/>
	
	
		<script src="jquery-mobile/jquery-1.7.1.min.js" type="text/javascript"></script>
		<script src="jquery-mobile/jquery.mobile-1.1.0.min.js" type="text/javascript"></script>
		<script src="flowplayer/flowplayer-3.2.8.min.js" type="text/javascript"></script>
		
		<script>
			function onBodyLoad()
			{		
				document.addEventListener("deviceready", onDeviceReady, false);
				
				
				
				
			}
			
			
			
		</script>
  	</head>
  	<body onload="onBodyLoad()">
  		<div data-role="page" id="campuses-live">
			<div data-position="fixed" data-role="header">
				<img src="assets/images/ccv-logo.png" class="logo">
				<div data-role="controlgroup" class="ui-btn-right" data-type="horizontal">
					<a href="default.aspx" rel="external"  data-role="button" data-icon="home" >Home</a>
				</div>
			</div>
			<div data-role="content">
				<h1 class="page-title">Settings</h1>
				
				
				<div  class="group content-wrap setting-panel">
					<h2>Encoders</h2>
					<ul>
						<li><a href="http://10.1.110.5">Peoria</a></li>
						<li><a href="http://10.6.110.150">Scottsdale</a></li>
						<li><a href="http://10.5.110.150">Surprise</a></li>
					</ul>
					
					<h2>DVR Administration</h2>
					<ul>
						<li><a href="http://www.ccvonline.com/rockchms/page/86" rel="external">Rock DVR Administration</a></li>
					</ul>
				</div>
			</div>
			
			
			<div data-role="footer" data-position="fixed" data-id="app-footer" class="ui-bar">
				
				<div class="ui-grid-a">
					<div class="ui-block-a"><h6>Christ's Church of the Valley</h6></div>
					<div class="ui-block-b contact-us">
						<div data-role="controlgroup" data-type="horizontal">
							<a href="http://www.ccvonline.com" data-role="button" data-mini="true">External Website</a>
							<a href="http://arena.ccvonline.com" data-role="button" data-mini="true">Arena</a>
						</div>
					</div>
				</div>
				
			</div>
  
  		</div>
	</body>
</html>