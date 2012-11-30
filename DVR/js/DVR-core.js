function onBodyLoad() {
    //document.addEventListener("deviceready", onDeviceReady, false);
    //$('#shareForm').show();
    $('#defaultClip').hide();

    if ($('#lblMsg').text() != '') {
        $('#lblMsg').show();
    } else {
        $('#lblMsg').hide();
    }

    //Clear form fields.
    $('#txtFrom').val();
    $('txtTo').val('');
    $('clipUrl').val('');
    $('txtBody').val(''); 
}

function parseQuerystring() {
    var nvpair = {};
    var qs = window.location.search.replace('?', '');
    var pairs = qs.split('&');
    $.each(pairs, function (i, v) {
        var pair = v.split('=');
        nvpair[pair[0]] = pair[1];
    });
    return nvpair;
};

function getCampus(c) {
    var loc;
    if (c == 1)
    { loc = 'peoria'; }
    else if (c == 6)
    { loc = 'scottsdale'; }
    else if (c == 5)
    { loc = 'surprise'; }
    sessionStorage.setItem('campus', loc);
    return loc;
};

function setTitles() {
    var title = sessionStorage.selClip.replace('y', 'y_').split('_');
    var svc = title[3].replace('00', ':00').replace('30', ':30');
    var day = title[1].split('-');
    day = '(' + day[1] + '/' + day[2] + ')';

    $('#recording-date').html(sessionStorage.campus + ' ' + title[2] + ' ' + day + ' ' + svc);

    if (title[2] == 'Sunday') {
        if (sessionStorage.campus == 'scottsdale') {
            $('#servicebar').append('<a id="900" class="service btn small multi" href="#">9:00 AM</a>');
            $('#servicebar').append('<a id="1030" class="service btn small multi" href="#">10:30 AM</a>');
        } else {
            $('#servicebar').append('<a id="900" class="service btn small multi" href="#">9:00 AM</a>');
            $('#servicebar').append('<a id="1030" class="service btn small multi" href="#">10:30 AM</a>');
            $('#servicebar').append('<a id="1200" class="service btn small multi" href="#">12:00 PM</a>');
        }
    } else if (title[2] == 'Saturday') {
       $('#servicebar').append('<a id="430" class="service btn small multi" href="#">4:30 PM</a>');
       $('#servicebar').append('<a id="600" class="service btn small multi" href="#">6:00 PM</a>');
    } else if (title[2] == '') {

    }
}

function shoutout() {
    alert('This tool is under development and may contain errors.');
};

function getData() {
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
            var max = 
            $.each(data, function (index, recording) {
                //RecordingName format: peoria_2012-9-22_Saturday430
                selDate = recording.RecordingName.replace('y', 'y_');
                selDate = selDate.split('_');
                rDate = recording.Date.split('T', 1);
                myDate = rDate.toString().replace('-', '').replace('-', '');
                rDate = rDate[0].split('-');
                rDate = '(' + rDate[1] + '/' + rDate[2] + ')';
                if (index == 0) {
                    $('#defaultClip').text(recording.RecordingName);
                }

                if (myDate < sessionStorage.prev) {
                    $('#menuitems').append('<li><a class="recDate" id="selDate" rel="external" href="recordings.aspx?CID=' + campusId + '" onclick="sessionStorage.selClip=\'' + recording.RecordingName + '\'">' + selDate[2] + ' ' + rDate + '</a></li>');
                }

                if (index == 30 || index == data.length-1) {
                    $("#menuitems").append('<br />');
                    $("#menuitems").append('<li><a href="default.aspx" rel="external">Live Feeds</a></li>');
                    //  $('#menuitems').listview('refresh');
                    return false;
                }
                sessionStorage.prev = myDate;
            });
        },
        error: function (xhr, status, error) {
            alert('REST ERROR:' + status + ' [' + error + ']: ' + xhr.responseText);

        }
    });
};

