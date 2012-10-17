<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<html>
  	<head>
  	<title>CCV Command Center DVR</title>
  
    	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
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
			    //document.addEventListener("deviceready", onDeviceReady, false);

			}

		</script>
  	</head>
  	<body onload="onBodyLoad()">
  		<div data-role="page" id="campuses-live" class="type-interior">
			<div data-role="header" data-position="fixed">
				<img src="../assets/images/ccv-logo.png" class="logo" alt="">
				<div data-role="controlgroup" class="ui-btn-right" data-type="horizontal">
					<a href="#" onClick="location.reload();" data-role="button" data-icon="refresh" >Reload Page</a>
					<a href="../settings.aspx" data-role="button" data-icon="gear" >Settings</a>
				</div>
			</div>
		    <div data-role="content">
                <div class="content-secondary">
                    <ul id="menuitems" data-role="listview" data-theme="a" data-divider-theme="g"></ul>
                </div>
                <div id="campus-container" class="content-primary">
                    <ul id="campus-recorded" class="group">
                        <li style="border: 0px;"> 
                            <div data-role="header"><h1 id="recording-date"></h1></div>
                            <a id="player" class="live-stream" href="http://pseudo01.hddn.com/vod/demo.flowplayervod/flowplayer-700.flv" style="display:block;width:520px;height:330px" > </a> 
			                <div data-role="footer" class="ui-bar">
                                <a id="430" class="service" href="#">4:30 PM</a>
                                <a id="600" class="service" href="#">6:00 PM</a>
                                <a id="900" class="service" href="#">9:00 AM</a>
                                <a id="1030" class="service" href="#">10:30 AM</a> 
                                <a id="1200" class="service" href="#">12:00 PM</a>                            
                            </div>
                        </li>
                    </ul>
                </div>
		    </div>			
			<script>
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
			            sessionStorage.setItem('campus', loc);
			            return loc;
			        },

			        setTitles: function () {
			            var title = sessionStorage.selClip.replace('y', 'y_').split('_');
			            var svc = title[3].replace('00', ':00').replace('30', ':30');

			            $('#recording-date').html(sessionStorage.campus + ' ' + title[2] + ' ' + title[1] + ' ' + svc);

			            var day = sessionStorage.selClip.replace('y', 'y_');
			            day = day.split('_');
			            day = day[2];

			            if (day == 'Sunday') {
			                $('#430').hide();
			                $('#600').hide();
			                $('#900').show();
			                $('#1030').show();
			                $('#1200').show();
			            } else if (day == 'Saturday') {
			                $('#430').show();
			                $('#600').show();
			                $('#900').hide();
			                $('#1030').hide();
			                $('#1200').hide();
			            } else if (day == '') {
			                $('#430').hide();
			                $('#600').hide();
			                $('#900').hide();
			                $('#1030').hide();
			                $('#1200').hide();
			            }
			        }
			    });
                
                function shoutout(){
                    alert('Under Development');
                };

                //Set Campus Headers
			    var params = jQuery.parseQuerystring();
			    var campusId = params.CID;
			    var campus = jQuery.getCampus(campusId);

			    //Setting Campus Title
			    $('#campus-title').html(campus + ' Campus');
                       
			    //Set Previous Date 
			    var prev = new Date();    
			    prev = prev.getFullYear() + '' + (prev.getMonth()+1) + '31';
                sessionStorage.prev = prev.toString();

			    //Set video REST url variable.
			    var Url = 'http://www.ccvonline.com/rockchms/api/recordings' + '?$filter=CampusId eq ' + campusId + '&$orderby=Date desc&apikey=CcvRockApiKey';

                //Get Recording Data
			    $.ajax({
			        type: 'GET',
			        contentType: 'application/json',
			        dataType: 'json',
			        url: Url,
			        success: function (data, status, xhr) {
			            var rDate = '';
			            var rDay = '';
			            var myDate = '';
			            var selDate = '';

			            $.each(data, function (index, recording) {
			                //RecordingName format: peoria_2012-9-22_Saturday430
			                selDate = recording.RecordingName.replace('y', 'y_');
			                selDate = selDate.split('_');
			                rDate = recording.Date.split('T', 1);
			                myDate = rDate.toString().replace('-', '').replace('-', '');

			                if (myDate < sessionStorage.prev) {
			                    $('#menuitems').append('<li><a class="recDate" id="selDate" rel="external" href="campus.aspx?CID=' + campusId + '" onclick="sessionStorage.selClip=\'' + recording.RecordingName + '\'">' + selDate[2] + ' ' + rDate + '</a></li>');
			                }

			                if (index == 30) {
			                    $("#menuitems").append('<br />');
			                    $("#menuitems").append('<li><a href="default.aspx">Live Feeds</a>');
			                    $('#menuitems').listview('refresh');
			                    return false;
			                }
			                sessionStorage.prev = myDate;
			            });
			        },
			        error: function (xhr, status, error) {
			            alert('REST ERROR:' + status + ' [' + error + ']: ' + xhr.responseText);
			        }
			    });

			    $('#campuses-live').live('pageshow', function () {
			        //Set Default Clip for First Load 
                    shoutout();
			        var firstrun = sessionStorage.selClip;
			        if (!firstrun) {
			            var today = new Date();
			            var sun = new Date();
			            sun.setDate(today.getDate() - today.getDay());
			            sessionStorage.selClip = sessionStorage.campus + '_' + sun.getFullYear() + '-' + (sun.getMonth()+1) + '-' + sun.getDate() + '_Sunday900';
			        }

			        jQuery.setTitles();
			        var selClip = sessionStorage.selClip + '/manifest.f4m?DVR&wowzadvrplayliststart=0';

			        flowplayer("player", "../flowplayer/flowplayer-3.2.9.swf",
				    {
				        clip: {
				            url: selClip,
				            urlResolvers: ['f4m'],
				            provider: 'httpstreaming',
				            baseUrl: "http://ccvwowza:1935/commandcenter/",
				            autoPlay: true
				        },
				        controls: {
				            all: false,
				            scrubber: false
				        },
				        plugins: {
				            f4m: { url: 'http://releases.flowplayer.org/swf/flowplayer.f4m-3.2.9.swf' },
				            httpstreaming: { url: 'http://releases.flowplayer.org/swf/flowplayer.httpstreaming-3.2.9.swf' },
				            sharing: {
				                url: 'http://releases.flowplayer.org/swf/flowplayer.sharing-3.2.11.swf',

				                buttons: {
				                    overColor: '#ff0000'
				                },
				                email: {
				                    subject: 'A cool video'
				                },
				                embed: {
				                    fallbackUrls: ['Extremists.mov']
				                },

				                facebook: {
				                    'shareWindow': '_blank'
				                },

				                twitter: false
				            },

				            dock: {
				                right: 15,
				                horizontal: false,
				                width: 10%,
				                autoHide: false
				            }
				        }
				    });
			    });


                // ON DATE CLICK
			    $('a.recDate').live('click', function () {
			        $f("player").play(sessionStorage.selClip + '/manifest.f4m?DVR&wowzadvrplayliststart=0');
			        jQuery.setTitles();
			    });

                //ON SERVICE CLICK
			    $('a.service').live('click', function () {
			        var selDate = sessionStorage.selClip;
			        selDate = selDate.replace('y', 'y_');
			        selDate = selDate.split('_', 3);

			        var clipname = selDate.toString().replace(',', '_').replace(',', '_');
			        var rSvc = $(this).attr("id").replace('00', ':00').replace('30', ':30');

			        sessionStorage.selClip = clipname + $(this).attr("id");
			        jQuery.setTitles();

			        //Set title and play video.
			        $('#recording-date').html(sessionStorage.campus + ' ' + selDate[2] + ' ' + selDate[1] + ' ' + rSvc);
			        $f("player").play(sessionStorage.selClip + '/manifest.f4m?DVR&wowzadvrplayliststart=0');
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