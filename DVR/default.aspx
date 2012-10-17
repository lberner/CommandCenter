<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<html>
  	<head>
  	<title>CCV Command Center DVR</title>
  
    	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no;" />
		<meta charset="utf-8">

		<link href="../jquery-mobile/jquery.mobile-1.1.0.min.css" rel="stylesheet" type="text/css"/>
		<link href="../jquery-mobile/ccv-mobile-bw.css" rel="stylesheet" type="text/css"/>
		<link href="../css/mobile.css" rel="stylesheet" type="text/css"/>
		<link href="../css/font-awesome.css" rel="stylesheet" type="text/css"/>
	    <link href="../css/split-view.css" rel="Stylesheet" type="text/css" />
	
		<script src="../jquery-mobile/jquery-1.7.1.min.js" type="text/javascript"></script>
		<script src="../jquery-mobile/jquery.mobile-1.1.0.min.js" type="text/javascript"></script>
		<script src="../flowplayer/flowplayer-3.2.8.min.js" type="text/javascript"></script>
		
		<script>
			function onBodyLoad()
			{
			    document.addEventListener("deviceready", onDeviceReady, false);

			}

		</script>
  	</head>
  	<body onload="onBodyLoad()">
  		<div data-role="page" id="campuses-live" class="type-interior">
			<div data-position="fixed" data-role="header">
				<img src="../assets/images/ccv-logo.png" class="logo">
				<div data-role="controlgroup" class="ui-btn-right" data-type="horizontal">
					<a href="#" onClick="location.reload();" data-role="button" data-icon="refresh" >Reload Page</a>
					<a href=../settings.aspx"  data-role="button" data-icon="gear" >Settings</a>
				</div>
			</div>
			<div data-role="content">
                <div class="content-secondary">
                    <ul id="menuitems" data-role="listview" data-theme="a" data-divider-theme="g">
                        <li><a href="campus.aspx?CID=1" rel="external">Peoria</a></li>
                        <li><a href="campus.aspx?CID=6" rel="external">Scottsdale</a></li>
                        <li><a href="campus.aspx?CID=5" rel="external">Surprise</a></li>
                    </ul>
                </div>
                <div id="campus-container" class="content-primary">
                    <ul id="campus-live" class="group">
                        <li>
                            <div data-role="header"><h1 id="vTitle"></h1></div>
    					    <a id="player" class="live-stream" href="http://pseudo01.hddn.com/vod/demo.flowplayervod/flowplayer-700.flv" style="display:block;width:520px;height:330px" > </a> 
			                <div data-role="footer" class="ui-bar">
                                <a class="Peoria" href="#">Peoria</a>
                                <a class="Scottsdale" href="#">Scottsdale</a>
                                <a class="Surprise" href="#">Surprise</a>                            
                            </div>
						    <div class="cc-button audio-toggle enabled">
							    <i class="mute icon-volume-custom"></i>
							    <span></span>
						    </div>
                        </li>
                    </ul>
                </div>
			</div>
            <script>

                $('#campuses-live').live('pageshow', function () {
                    
                    $('#vTitle').html("Peoria Live");
                    // setup players
                    flowplayer("player", "../flowplayer/flowplayer-3.2.9.swf",
					{
					    clip: {
					        url: 'peoria',
					        live: true,
					        provider: 'rtmp',
					        onStart: function () { $f("player").unmute(); }
					    },
					    controls: {
					        all: false,
					        scrubber: false
					    },
					    plugins: {
					        rtmp: {
					            url: '../flowplayer/flowplayer.rtmp-3.2.9.swf',
					            netConnectionUrl: 'rtmp://ccvwowza-out.ccvonline.com:1935/commandcenter'
					        }
					    }
					});

					$('a.Peoria').live('click', function () {
					    $('#vTitle').html("Peoria Live");
                        $f("player").play('peoria');
                    });

                    $('a.Scottsdale').live('click', function () {
                        $('#vTitle').html("Scottsdale Live");
                        $f("player").play('scottsdale');
                    });

                    $('a.Surprise').live('click', function () {
                        $('#vTitle').html("Surprise Live");
                        $f("player").play('surprise');
                    });

                    $('div.audio-toggle').click(function (event) {
                        //$f("surprise-player").mute();
                        // set flag if user clicked on current item this will note that they wish to mute current channel
                        var currentItem = false;
                        if ($(this).is('.enabled')) {
                            currentItem = true;
                        }

                        // mute all videos
                        $('.audio-toggle').each(function (index, value) {
                            $(this).removeClass('enabled');
                            $(this).addClass('muted');
                        });

                        $f("*").each(function () {
                            this.mute();
                        });

                        // get id of video player
                        var playerId = $(this).siblings('a').attr('id');
                        //alert(playerId);

                        // enabled selected video unless it is the active one, then mute
                        if (currentItem) {
                            $f(playerId).mute();
                        } else {
                            $(this).addClass('enabled');
                            $f(playerId).unmute();
                        }

                        e.prevendDefault();
                    });
                });
			
            </script>
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