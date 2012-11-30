<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<html>
  	<head>
  	<title>CCV Command Center DVR</title>
      	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no;" />
		<meta charset="utf-8">

		<link rel="stylesheet" type="text/css" href="http://releases.flowplayer.org/5.1.1/skin/minimalist.css" />
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
        <link rel="stylesheet" type="text/css" href="css/bootstrap-responsive.min.css" />
        <link rel="stylesheet" type="text/css" href="css/dvr-mobile.css"/>
        <link rel="stylesheet" type="text/css" href="css/ccv-mobile.css" />
	    <link rel="stylesheet" type="text/css" href="css/components.css" />
        <link rel="stylesheet" type="text/css" href="css/main.css" />

        <script src="js/DVR-core.js" type="text/javascript"></script>
        <script src="../jquery-mobile/jquery-1.7.1.min.js" type="text/javascript" ></script>
		<script src="../flowplayer/flowplayer-3.2.8.min.js" type="text/javascript"></script>		
  	</head>

  	<body onload="onBodyLoad()" class="header-fixed footer-fixed">
        <header>
			<div class="stich">
                <object id="logo" type="image/svg+xml" data="assets/images/ccv-logo-full.svg"></object>
			</div>
		</header>
       
        <section id="content" class="split-view">
			<div class="row-fluid">
                <div class="span4">
                    <ul id="menuitems" class="nav nav-list title">
                        <li><a href="recordings.aspx?CID=1" rel="external">Peoria</a></li>
                        <li><a href="recordings.aspx?CID=6" rel="external">Scottsdale</a></li>
                        <li><a href="recordings.aspx?CID=5" rel="external">Surprise</a></li>
                    </ul>
                </div>

                 <div id="campus-container" class="span8">
  		            <div class="grid-container">
                         <ul id="campus-live" class="unstyled">
                            <li>
                                <div><h1 id="vTitle"></h1></div>
    				            <a id="player" href="http://pseudo01.hddn.com/vod/demo.flowplayervod/flowplayer-700.flv" style="display:block;width:520px;height:330px" > </a>
			                    <div class="btn-group center">
                                    <a class="Peoria btn small multi" href="#">Peoria</a>
                                    <a class="Scottsdale btn small multi" href="#">Scottsdale</a>
                                    <a class="Surprise btn small multi" href="#">Surprise</a>                            
                                </div><br />
                            </li>
                        </ul>
                    </div>
                 </div>
             </div>     
        </section>   			
        
        <footer>
		    <div class="stich center">
				<ul class="btn-group">
					<li><a href="tel:6233762444" class="btn small campus-phone">623.376.2444</a></li>
					<li><a href="http://www.ccvonline.com" class="btn small">Visit Our Website</a></li>
				</ul>
		    </div>
	    </footer>

        <script language="javascript">
            $("document").ready(function() {
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

                    e.preventDefault();
                });
            });	
        </script>
	</body>
</html>