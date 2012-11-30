<%@ Page Language="C#" AutoEventWireup="true" CodeFile="recordings_v2.aspx.cs" Inherits="DVR_recordings" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  	<head>
  	<title>CCV Command Center DVR</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=false;">
		<meta charset="utf-8">

		<link href="../jquery-mobile/jquery.mobile-1.1.0.min.css" rel="stylesheet" type="text/css"/>
		<link href="../jquery-mobile/ccv-mobile-bw.css" rel="stylesheet" type="text/css"/>
		<link href="../css/mobile.css" rel="stylesheet" type="text/css"/>
		<link href="../css/font-awesome.css" rel="stylesheet" type="text/css"/>
	    <link href="../css/split-view.css" rel="stylesheet" type="text/css" />

        <script type="text/javascript" src="js/DVR-core.js"></script>
        <script src="../jquery-mobile/jquery-1.7.1.min.js" type="text/javascript"></script>
        <script src="../jquery-mobile/jquery.mobile-1.1.0.min.js" type="text/javascript" ></script>
		<script src="../flowplayer/flowplayer-3.2.8.min.js" type="text/javascript"></script>
		
  	</head>
  	<body onload="onBodyLoad()">
  		<div data-role="page" id="campuses-live" class="type-interior">
			<div data-role="header" data-position="fixed">
				<img src="../assets/images/ccv-logo.png" class="logo" alt="">
			</div>
		    <div data-role="content">
                <div class="content-secondary">
                    <ul id="menuitems" data-role="listview" data-theme="a" data-divider-theme="g"></ul>
                    <label id="defaultClip" style="visibility: hidden"></label>
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
                        <form id="frmEmail" method="post" data-ajax="false" runat="server"> 
                        <div id="shareButton" style="left">
                            <a href="#" id="shareBtn" data-rel="popup" data-role="button" data-inline="true" data-mini="true" data-corners="true" data-shadow="true" overlayTheme="a" dismissable="true">
                            Share</a><br /><asp:Label ID="lblMsg" runat="server" Text=""></asp:Label>
                        </div>
                        <div id="shareForm" style="align: center display=none" class="popup" runat="server">                        
                            <div data-role="fieldcontain" data-theme="a" style="padding:10px 20px; text-align:left;" class="ui-dialog">
				                <h3>Share Video</h3>  
                                <div align="center">
                                    <a id="start" rel="external" data-role="button" data-inline="true" data-mini="true" runat="server">Start</a> <asp:Label id="lblstart"></asp:Label>
                                    <a id="end" rel="external" data-role="button" data-inline="true" data-mini="true" runat="server">End</a> <asp:Label id="lblend"></asp:Label><br />
                                </div>
                                <asp:HiddenField ID="clipUrl" runat="server"></asp:HiddenField> 
                                <label for="txtFrom" data-mini="true">From:</label> <asp:TextBox id="txtFrom" value="" data-theme="a" data-mini="true" runat="server"/><br />
		                        <label for="txtTo">To:</label><asp:TextBox id="txtTo" value="" data-theme="a" data-mini="true" runat="server"></asp:TextBox><br />
		                        <label for="txtBody">Message:</label><asp:TextBox id="txtBody" data-theme="a" data-mini="true" runat="server" TextMode="MultiLine" Wrap="true" Rows="5"></asp:TextBox><br />
                                <div align="center"><asp:Button ID="btnSave" runat="server" Text="Send" data-theme="b" data-inline="true" data-mini="true" style="text-align:center" onclick="btnEmail_Click"></asp:Button></div>
				            </div>
                        </div>
                        </form>
                    </ul>
                </div>
		    </div>			
			<script language="javascript">
            //Set Campus Headers
                var params = parseQuerystring();
                var campusId = params.CID;
                var campus = getCampus(campusId);
                //$('#shareForm').hide();

                //Setting Campus Title
                $('#campus-title').html(campus + ' Campus');

                //Set Previous Date 
                var prev = new Date();
                prev = prev.getFullYear() + '' + (prev.getMonth() + 1) + '31';
                sessionStorage.prev = prev.toString();
  
                //Set video REST url variable.
                var Url = 'http://www.ccvonline.com/rockchms/api/recordings' + '?$filter=CampusId eq ' + campusId + '&$orderby=Date desc&apikey=CcvRockApiKey';

                 //Get Recording Data  
                 getData();
	             
			    $('#campuses-live').live('pageshow', function () {
   			        var selClip = '';
			        var start = 0;

                    //Set Default Clip for First Load 
			        if (!sessionStorage.selClip) {
			            var today = new Date();
			            var sun = new Date();
			            sun.setDate(today.getDate() - today.getDay());
                        if ($('#defaultClip').text()) {
                             sessionStorage.selClip =$('#defaultClip').text();
                        } else {
                            sessionStorage.selClip = sessionStorage.campus + '_' + sun.getFullYear() + '-' + (sun.getMonth() + 1) + '-' + sun.getDate() + '_Sunday900';
                        }
			        }
                    
			        if (params.clipUrl) {
                        selClip = params.clipUrl.split('/', 1);
                        sessionStorage.selClip = selClip;
                        selClip = selClip + '/manifest.f4m?DVR&wowzadvrplayliststart=' + params.start + '&wowzadvrplaylistduration=' + params.dur;
			        } else {
			            selClip = sessionStorage.selClip + '/manifest.f4m?DVR&wowzadvrplayliststart=0';
			        }

                    setTitles();   

			        flowplayer("player", "../flowplayer/flowplayer-3.2.9.swf",
				    {
				        plugins: {
				            f4m: { url: 'http://releases.flowplayer.org/swf/flowplayer.f4m-3.2.9.swf' },
				            httpstreaming: { url: 'http://releases.flowplayer.org/swf/flowplayer.httpstreaming-3.2.9.swf' },
				        },
				        clip: {
				            url: selClip,
				            urlResolvers: ['f4m'],
				            provider: 'httpstreaming',
				            baseUrl: "http://ccvwowza:1935/commandcenter/",
				            autoPlay: true,
				        },
				        controls: {
				            all: false,
				            scrubber: false
				        },
                        showErrors: false,
                        onError : function(errorCode, errorMessage) {
                            if (errorCode === 303) {
                                    sessionStorage.selClip = $('#defaultClip').text();
                                    $f("player").play('http://www.ccvonline.com/CommandCenter/assets/images/fuzzy-tv-yellow.jpg');
                            }
                        }
				    });
			    });

                // ON DATE CLICK
			    $('a.recDate').live('click', function () {
			        $f("player").play(sessionStorage.selClip + '/manifest.f4m?DVR&wowzadvrplayliststart=0');
			        setTitles();
			    });

                // ON SERVICE CLICK
			    $('a.service').live('click', function (e) {
			        var selDate = sessionStorage.selClip;
			        selDate = selDate.replace('y', 'y_');
			        selDate = selDate.split('_', 3);

			        var clipname = selDate.toString().replace(',', '_').replace(',', '_');
			        var rSvc = $(this).attr("id").replace('00', ':00').replace('30', ':30');

			        sessionStorage.selClip = clipname + $(this).attr("id");
			        setTitles();

			        // Set title and play video.
			        $('#recording-date').html(sessionStorage.campus + ' ' + selDate[2] + ' ' + selDate[1] + ' ' + rSvc);
                    location.reload();
			    });
                // SHARE VIDEO CLICK
                $('#shareBtn').live('click', function (e) {
                    if ( $('#shareForm').is(':visible')) {
                        $('#shareForm').hide();                    
                    } else {
                        $('#shareForm').show();
                    } 
                });
                $('#start').live('click', function (e) {
                    sessionStorage.startClip = $f("player").getTime().toString();
                    sessionStorage.startClip = sessionStorage.startClip.split('.', 1);
                    sessionStorage.pageUrl = 'http://www.ccvonline.com/commandcenter/dvr/recordings.aspx?CID=' + campusId + '&clipUrl=' + sessionStorage.selClip + '/manifest.f4m?DVR&start=' + start;
                    $('#lblstart').html(sessionStorage.startClip);
                });
                $('#end').live('click', function (e) {
                    sessionStorage.endClip = $f("player").getTime().toString();
                    sessionStorage.endClip = sessionStorage.endClip.split('.', 1);
                    var start = (sessionStorage.startClip)*1000;
                    var dur = (sessionStorage.endClip)*1000 - (sessionStorage.startClip)*1000;
                    sessionStorage.pageUrl = 'http://www.ccvonline.com/commandcenter/dvr/recordings.aspx?CID=' + campusId + '&clipUrl=' + sessionStorage.selClip + '/manifest.f4m?DVR&start=' + start + '&dur=' + dur ;
                    $('#lblend').html(sessionStorage.endClip);
                    $('#clipUrl').val(sessionStorage.pageUrl);
                });
            //});
                
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