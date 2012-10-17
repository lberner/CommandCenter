<!DOCTYPE html>
<html>
  	<head>
  	<title>CCV Command Center DVR</title>
  
    	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
		<meta charset="utf-8">

		<link href="../jquery-mobile/jquery.mobile-1.1.0.min.css" rel="stylesheet" type="text/css"/>
		<link href="../jquery-mobile/ccv-mobile-bw.css" rel="stylesheet" type="text/css"/>
		<link href="../css/mobile.css" rel="stylesheet" type="text/css"/>
		<link href="../css/font-awesome.css" rel="stylesheet" type="text/css"/>
	
		<script src="../jquery-mobile/jquery-1.7.1.min.js" type="text/javascript"></script>
		<script src="../jquery-mobile/jquery.mobile-1.1.0.min.js" type="text/javascript"></script>
		<script src="../flowplayer/flowplayer-3.2.8.min.js" type="text/javascript"></script>
		
		<script>
			function onBodyLoad()
			{
			    document.addEventListener("deviceready", onDeviceReady, false);
			    	   
			}

			//Create key/values from querystring.
			jQuery.extend({
			    parseQuerystring: function () {
			        var nvpair = {};
			        var qs = window.location.search.replace('?', '');
			        var pairs = qs.split('&');
			        $.each(pairs, function (i, v) {
			            var pair = v.split('=');
			            nvpair[pair[0]] = pair[1];
			        });
			        return nvpair;
			    },

			    getCampus: function (c) {
			        var loc;
			        if (c == 1)
			        { loc = 'peoria'; }
			        else if (c == 6)
			        { loc = 'scottsdale'; }
			        else if (c == 5)
			        { loc = 'surprise'; }
			        sessionStorage.campus = loc;
			        return loc;
			    }
			});

			$(document).ready(function () {
			    //Set Campus Headers
			    var params = jQuery.parseQuerystring();
			    var campusId = params.CID;
			    var campus = jQuery.getCampus(campusId);


			    //Set campus infor in local storage
			    localStorage.setItem('_campusId', campusId);
			    localStorage.setItem('_campus', campus);

			    //Set video REST url variable.
			    var Url = 'http://www.ccvonline.com/rockchms/api/recordings' + '?$filter=CampusId eq ' + campusId + '&$orderby=Date desc&apikey=CcvRockApiKey'
			    var rDate = '';
			    var rDay = '';

			    //Set Previous Date 
			    var prev = new Date();
			    var prev = prev.getFullYear() + '/' + prev.getMonth() + '/' + prev.getDay() + 2;

			    //Set Page & Video Titles
			    $("#campus-title").html(campus + " Campus");
			    $('#Svc1').hide();
			    $('#Svc2').hide();
			    $('#Svc3').hide();
			    $('#Svc4').hide();
			    $('#Svc5').hide();

			    $.ajax({
			        type: 'GET',
			        contentType: 'application/json',
			        dataType: 'json',
			        url: Url,
			        success: function (data, status, xhr) {
			            $.each(data, function (index, recording) {
			                rDate = recording.Date.split('T', 1);                
			                rDay = recording.Label.split(' ', 1);
			               
			                if (rDate < prev) {
			                    $('#menuitems').append('<li><a class="recDate" href="bycampus.aspx" onclick="sessionStorage.selDate=' + rDay + '_' + rDate + '">' + rDay + ' ' + rDate + '</a></li>');
			                }

			                if (index == 25) {
			                    $("#menuitems").append('<br />');
			                    $("#menuitems").append('<li><a href="default.aspx">Live Feeds</a>');
			                    $('#menuitems').listview('refresh');

			                    return false;
			                }

			                prev = recording.Date.split('T', 1);
			                localStorage.setItem('defaultRecording', data[0].Label);
			            });
			        },
			        error: function (xhr, status, error) {
			            alert(status + ' [' + error + ']: ' + xhr.responseText);
			        }
			    });

			});
            
		</script>
  	</head>
  	<body onload="onBodyLoad()">
  		<div data-role="page" id="campuses-live">
			<div data-position="fixed" data-role="header">
				<img src="../assets/images/ccv-logo.png" class="logo">
				<div data-role="controlgroup" class="ui-btn-right" data-type="horizontal">
					<a href="#" onClick="location.reload();" data-role="button" data-icon="refresh" >Reload Page</a>
					<a href="../settings.aspx" data-role="button" data-icon="gear" >Settings</a>
				</div>
			</div>
			<div data-role="content">
				<div id="menu" class="menu">
                    <ul id="menuitems" data-role="listview" data-theme="a" data-divider-theme="g">
                        <li data-role="list-divider"><h1>Recordings by Campus</h1></li>
                    </ul>
				</div>
                <div id="campus-container" class="group">
                    <h1 id="campus-title" align="center"></h1>
                    <ul id="campus-recorded" class="group">
                        <li>
                            <div data-role="header"><h1 id="recording-date"></h1></div>
                            <a id="player" class="live-stream" href="http://pseudo01.hddn.com/vod/demo.flowplayervod/flowplayer-700.flv" style="display:block;width:520px;height:330px" > </a> 
			                <div data-role="footer" class="ui-bar" align=center>
                                <a id="Svc1" class="service" rel="external" href="#430">4:30 PM</a>
                                <a id="Svc2" class="service" rel="external" href="#600">6:00 PM</a>
                                <a id="Svc3" class="service" rel="external" href="#900">9:00 AM</a>
                                <a id="Svc4" class="service" rel="external" href="#1030">10:30 AM</a> 
                                <a id="Svc5" class="service" rel="external" href="#1200">12:00 PM</a>                             
                            </div>
					        <%--div class="cc-button audio-toggle enabled">
						        <i class="mute icon-volume-custom"></i>
                                <span></span>
					        </div>--%>
                        </li>
                    </ul>
                </div>
			</div>
			
			<script>

               var selClip = localStorage.getItem('defaultRecording') + '/manifest.f4m?DVR&wowzadvrplayliststart=0';
               var campusId = localStorage.getItem('_campusId');
               var campus = localStorage.getItem('_campus');  
               
               //Display recording title.
               var title = localStorage.getItem('defaultRecording').split('_');
               var title = title[0];
               $('#recording-date').html(title);

			    $('#campuses-live').live('pageshow', function () {                
			        //Setup Players
                    flowplayer("player", "../flowplayer/flowplayer-3.2.9.swf",
					{
					    clip: {
					        url: selClip,
					        urlResolvers: ['f4m'],
        					provider: 'httpstreaming',
        					baseUrl: "http://ccvwowza:1935/commandcenter/"
					    },
					    controls: {
					        all: false,
					        scrubber: false
					    },
					    plugins: {
					        f4m: { url: "http://releases.flowplayer.org/swf/flowplayer.f4m-3.2.9.swf" },
                            httpstreaming: { url: "http://releases.flowplayer.org/swf/flowplayer.httpstreaming-3.2.9.swf" },
					    }
					});


                    $('a.recDate').live('click', function() {
                        var rDate = $('a.recDate').attr('href').replace('?', '');
                        var rDay = rDate.split('_', 1);
                        //alert('rDate:' + rDate); alert('rDay:' + rDay);
                        //alert($('#dlink').attr('href'));
                        //alert('Session:' + sessionStorage.selDate);
                        
                        //Save date & day to local storage.
                        localStorage.setItem('_selDate', rDate);
                        localStorage.setItem('_selDay', rDay);

                        $('#recording-date').html(rDate.replace('_',' '));

                        if (rDay == 'Saturday') {
                              $('#Svc1').show();
                              $('#Svc2').show();
                              $('#Svc3').hide();
                              $('#Svc4').hide();
                              $('#Svc5').hide();  
                        } else if (rDay == 'Sunday') {
                              $('#Svc1').hide();
                              $('#Svc2').hide();
                              $('#Svc3').show();
                              $('#Svc4').show();
                              $('#Svc5').show();
                        } else {
                              $('#Svc1').hide();
                              $('#Svc2').hide();
                              $('#Svc3').hide();
                              $('#Svc4').hide();
                              $('#Svc5').hide();
                        }
                    });

			        $('a.service').live('click', function () {
                        var rService = $('a.service').attr('href').replace('#', '');
                        var campus = localStorage.getItem('_campus');
                        var rDate = localStorage.getItem('_selDate');
                        var rDay = localStorage.getItem('_selDay');
                       
                        if (rService = 430) {
                            selClip = campus + '_' + rDate + '_' + rDay + '430/manifest.f4m?DVR&wowzadvrplayliststart=0';
                        } else if (rService = 600) {
                            selClip = campus  + '_' + rDate + '_' + rDay + '600/manifest.f4m?DVR&wowzadvrplayliststart=0';
                        } else if (rService = 900) {
                            selClip = campus + '_' + rDate + '_' + rDay + '900/manifest.f4m?DVR&wowzadvrplayliststart=0';
                        } else if (rService = 1030) {
                            selClip = campus + '_' + rDate + '_' + rDay + '1030/manifest.f4m?DVR&wowzadvrplayliststart=0';
                        } else if (rService = 1200) {
                            selClip = campus + '_' + rDate + '_' + rDay + '1200/manifest.f4m?DVR&wowzadvrplayliststart=0';
                        }
 			            //alert(selClip);
                        $f("player").play(selClip);
			        });

			       

			        $('div.audio-toggle').click(function (event) {
			            event.prevendDefault();
			            alert("toggling");
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

			            //event.prevendDefault();
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