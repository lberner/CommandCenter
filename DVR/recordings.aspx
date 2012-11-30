<%@ Page Language="C#" AutoEventWireup="true" CodeFile="recordings.aspx.cs" Inherits="DVR_recordings" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>CCV Command Center DVR</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=false;">
    <meta charset="utf-8">
    <link rel="stylesheet" type="text/css" href="http://releases.flowplayer.org/5.1.1/skin/minimalist.css" />
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="css/bootstrap-responsive.min.css" />
    <link rel="stylesheet" type="text/css" href="css/ccv-mobile.css" />
    <link rel="stylesheet" type="text/css" href="css/main.css" />
    <link rel="stylesheet" type="text/css" href="css/components.css" />
    <link rel="stylesheet" type="text/css" href="css/dvr-mobile.css" />
    
    <script src="js/DVR-core.js" type="text/javascript"></script>
    <script src="../jquery-mobile/jquery-1.7.1.min.js" type="text/javascript"></script>
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
                    <ul id="menuitems" class="nav nav-list title"></ul>
                    <label id="defaultClip" style="visibility: hidden"></label>
                </div>

                <div id="campus-container" class="span8">
                    <div class="grid-container">	
                        <ul id="campus-live" class="unstyled">
                            <li> 
                               <div><h1 id="recording-date"></h1></div>
                                <a id="player" href="http://pseudo01.hddn.com/vod/demo.flowplayervod/flowplayer-700.flv" style="display:block;width:520px;height:330px" ></a>
                                <div class="btn-group center"> 
                                    <ul id="servicebar" class="btn-group"></ul>
                                </div><br />                             
                                <form id="frmEmail" method="post" class="nav-form" data-ajax="false" runat="server"> 
                                <asp:ScriptManager ID="ScriptManager" runat="server"></asp:ScriptManager>
                                <asp:UpdatePanel runat="server" id="pnlUpdate"> 
                                <ContentTemplate>    
                                    <div id="shareButton">
                                        <asp:Button id="shareBtn" runat="server" text="Share" class="btn small" onclick="btnShare_click"></asp:Button><br /><asp:Label ID="lblMsg" runat="server" Text=""></asp:Label>
                                    </div>
                                    <div align="center">
                                        <div id="shareForm">              
                                            <asp:Panel id="pnlEmailForm" runat="server" Visible="false">
                                            <div class="content">Scrub to a spot in the video and click the start and end buttons to capture the times.</div>
                                                <div>
                                                    <a id="start" rel="external" class="btn small single" runat="server">Start</a><asp:Label id="lblstart"></asp:Label> 
                                                    <a id="end" rel="external" class="btn small single" runat="server">End</a><asp:Label id="lblend"></asp:Label>
                                                </div>
                                                <div>
                                                    <asp:HiddenField ID="clipUrl" runat="server"></asp:HiddenField> 
                                                    <asp:TextBox id="txtFrom" class="txtfield" value="" Text="Your email address:" runat="server"/></asp:TextBox><br />
		                                            <asp:TextBox id="txtTo" class="txtfield" value="" text="Email(s) to:" runat="server"></asp:TextBox><br />
                                                    <asp:TextBox id="txtBody" class="txtfield" runat="server" Text="Message" TextMode="MultiLine" Wrap="true" Rows="5" Columns="30"></asp:TextBox><br />
                                                    <div><asp:Button ID="btnSave" runat="server" text="Send" class="btn small" onclick="btnEmail_Click"></asp:Button></div>
                                                </div>
                                            </asp:Panel>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </form>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</section>
    <footer>
		    <div class="stich center">
				<ul class="btn-group">
					<li><a href="tel:6233762444" class="btn small multi">623.376.2444</a></li>
					<li><a href="http://www.ccvonline.com" class="btn small multi">Visit Our Website</a></li>
				</ul>
		    </div>
	    </footer>
    <script language="javascript">
           
            //Set Campus Headers
            var params = parseQuerystring();
            var campusId = params.CID;
            var campus = getCampus(campusId);

            //Set Previous Date 
            var prev = new Date();
            prev = prev.getFullYear() + '' + (prev.getMonth() + 1) + '31';
            sessionStorage.prev = prev.toString();
  
            //Set video REST url variable.
            var Url = 'http://www.ccvonline.com/rockchms/api/recordings' + '?$filter=CampusId eq ' + campusId + '&$orderby=Date desc&apikey=CcvRockApiKey';

            //Get Recording Data  
            getData();
	             
            $("document").ready(function() {
                var selClip = '';
			    var start = 0;
                var today = new Date();
			    var sun = new Date();
			    sun.setDate(today.getDate() - today.getDay());

                //Set Default Clip for First Load 
			    if (!sessionStorage.selClip) {
                    if ($('#defaultClip').text()) {
                        sessionStorage.selClip =$('#defaultClip').text();
                    } else {
                        sessionStorage.selClip = sessionStorage.campus + '_' + sun.getFullYear() + '-' + (sun.getMonth() + 1) + '-' + sun.getDate() + '_Sunday900';
                    }
                } else if (campus != sessionStorage.selClip.split('_', 1)) {
                    var myDate = sessionStorage.selClip.split('_', 1);
                    sessionStorage.selClip = sessionStorage.campus + '_' + sun.getFullYear() + '-' + (sun.getMonth() + 1) + '-' + sun.getDate() + '_Sunday900';
                }

			    if (params.clipUrl) {
                    selClip = params.clipUrl.split('/', 1);
                    sessionStorage.selClip = selClip;
                    selClip = selClip + '/manifest.f4m?DVR&wowzadvrplayliststart=' + params.start + '&wowzadvrplaylistduration=' + params.dur;
			    } else {
			        selClip = sessionStorage.selClip + '/manifest.f4m?DVR&wowzadvrplayliststart=0';
			    }

                setTitles();   

                //Check Device Type
                if (navigator.userAgent.match(/Android/i)
                    || navigator.userAgent.match(/webOS/i)
                    || navigator.userAgent.match(/iPhone/i)
                    || navigator.userAgent.match(/iPad/i)
                    || navigator.userAgent.match(/iPod/i)
                    || navigator.userAgent.match(/BlackBerry/i)
                    || navigator.userAgent.match(/Safari/i)
                ) {} 
                else {}

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
                                //alert("Sorry, unable to play video. Please choose another date.");
                                //location.reload();
                        }
                    }
				}); 
            });

            // ON DATE CLICK UPDATE CLIP DATE AND PLAY VIDEO
			$('a.recDate').live('click', function () {
			    $f("player").play(sessionStorage.selClip + '/manifest.f4m?DVR&wowzadvrplayliststart=0');
			    setTitles();
			});

            // ON SERVICE CLICK UPDATE CLIP SERVICE TIME.
			$('a.service').live('click', function (e) {
			    var selDate = sessionStorage.selClip;
			    selDate = selDate.replace('y', 'y_');
			    selDate = selDate.split('_', 3);

			    var clipname = selDate.toString().replace(',', '_').replace(',', '_');
			    var rSvc = $(this).attr("id").replace('00', ':00').replace('30', ':30');

			    sessionStorage.selClip = clipname + $(this).attr("id");
			    setTitles();

			    //SET TITLE AND PLAY VIDEO
			    $('#recording-date').html(sessionStorage.campus + ' ' + selDate[2] + ' ' + selDate[1] + ' ' + rSvc);
                location.reload();
			});

            $('#start').live('click', function (e) {
                sessionStorage.startClip = $f("player").getTime().toString();
                sessionStorage.startClip = sessionStorage.startClip.split('.', 1);
                sessionStorage.pageUrl = 'http://www.ccvonline.com/commandcenter/dvr/recordings.aspx?CID=' + campusId + '&clipUrl=' + sessionStorage.selClip + '/manifest.f4m?DVR&start=' + start;
                var time = (sessionStorage.startClip/60).toFixed(0) < 1 ? " Seconds":" Minutes";
                $('#start').html("Start at " + (sessionStorage.startClip/60).toFixed(0) + ":" + (sessionStorage.startClip % 60) + time);
            });
            $('#end').live('click', function (e) {
                sessionStorage.endClip = $f("player").getTime().toString();
                sessionStorage.endClip = sessionStorage.endClip.split('.', 1);
                var start = (sessionStorage.startClip)*1000;
                var dur = (sessionStorage.endClip)*1000 - (sessionStorage.startClip)*1000;
                sessionStorage.pageUrl = 'http://www.ccvonline.com/commandcenter/dvr/recordings.aspx?CID=' + campusId + '&clipUrl=' + sessionStorage.selClip + '/manifest.f4m?DVR&start=' + start + '&dur=' + dur ;
                var time = (sessionStorage.endClip/60).toFixed(0) < 1 ? " Seconds":" Minutes";
                $('#end').html("End at " + (sessionStorage.endClip/60).toFixed(0) + ":" + (sessionStorage.endClip % 60) + time);
                $('#clipUrl').val(sessionStorage.pageUrl);
            });
    </script>
</body>
</html>
