/* 
<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	Global Variables
<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> 
*/

var currentCampus = null;

var campusData  = [
    {
        text: "Peoria",
        value: 1,
        selected: false,
        phone: "623.376.2444"
    },
    {
        text: "Scottsdale",
        value: 6,
        selected: false,
        phone: "480.502.9800"
    },
    {
        text: "Surprise",
        value: 5,
        selected: false,
        phone: "623.875.9000"
    }
];

// declare a prayer object
function PrayerRequest(id,name,category,date,request) {
        this.Id = id;
        this.Name=name;
        this.Category=category;
        this.Date=date;
        this.Request=request;
}

// declare an ad object
function Ad(title, highlightImage, contactEmail, contactPhone, contactName, url, detail) {
        this.Title = title;
        this.HighlightImage = highlightImage;
        this.ContactEmail = contactEmail;
        this.ContactPhone = contactPhone;
        this.ContactEmail = contactEmail;
        this.ContactName = contactName;
        this.Url = url;
        this.Detail = detail;
}

// declare a group object
function Group(id, groupName, leaderName, meetingDay, latitude, longitude, distance, averageAge, size) {
        this.Id=id;
        this.GroupName=groupName;
        this.LeaderName=leaderName;
        this.MeetingDay=meetingDay;
        this.Latitude=latitude;
        this.Longitude=longitude;
        this.Distance=distance;
        this.AverageAge=averageAge;
        this.Size=size;
}


var URL_CAMPUS_INFO = 'http://mobileapp.ccvonline.com/arena/MobileApp/MobileXML.aspx?r=False&m=1&p=40&c=';

/* 
<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	Helper Functions
<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> 
*/

function setCampusPhone(campusId) {
    var campusPhone = getCampusPhone(campusId);
    
    $('.btn.campus-phone').text(campusPhone);
	$('.btn.campus-phone').attr("href", 'tel:' + campusPhone.replace(".", ""));
}

function getCampusPhone(campusId) {
	var campusPhone = -1;

	$(campusData).each(function(index) {
		if (this.value == campusId) {
			campusPhone = this.phone;
		}
	});
	return campusPhone;
}

function setCurrentCampus(newCampusId) {
	currentCampus = newCampusId;
	localStorage.setItem("current-campus", newCampusId);
	
	// change the footer of the page
	setCampusPhone(newCampusId);
	
	console.log("Set current campus to: " + newCampusId);
	
	// TODO: get new campus ad?
}

function campusIdToIndex(campusId) {
	var campusIndex = -1;

	$(campusData).each(function(index) {
		if (this.value == campusId) {
			campusIndex = index;
		}
	});
	return campusIndex;
}

function loadCampusAds(campusId) {
	var requestUrl = URL_CAMPUS_INFO + campusId;
	
	console.log('[Core]Requesting:' + requestUrl);

    // get updated xml for populating ads and prayers
    $.ajax({
	    type: 'GET',
	    url: requestUrl,
	    async: false,
	    dataType: 'xml',
	    error: function(xhr, status, error) {
			//navigator.notification.alert("An error occurred trying to retrieve data from the CCV server.  Please ensure you have a connection to the Internet.", alertDismissed, 'Ooops...', 'Continue');
		},
	    success: function(xml) {
	        
           // get ads
           $(xml).find('ad').each(function(){
                /*localStorage.setItem('ad-title', $(this).attr('title'));
			    localStorage.setItem('ad-highlight-image-url', $(this).attr('highlight-image'));
			    localStorage.setItem('ad-contact-email', $(this).attr('contact-email'));
			    localStorage.setItem('ad-contact-phone', $(this).attr('contact-phone'));
			    localStorage.setItem('ad-contact-name', $(this).attr('contact-name'));
			    localStorage.setItem('ad-url', $(this).attr('url'));
				localStorage.setItem('ad-detail', $(this).find('details').text());*/
			});
	    }
	});
}

/*
Note the campus data object can also have properties for description and image ala
	{
		text: "Foursquare",
		value: 4,
		selected: false,
		description: "Description with Foursquare",
		imageSrc: "http://dl.dropbox.com/u/40036711/Images/foursquare-icon-32.png"
	}
*/

/* 
<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	Global Page Load
		The logic below will run on the start of every page
<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> 
*/
$(document).ready(function() {
	
	// campus check logic
	// check that this isn't the campus selector page (loop occurs if true)
	if (location.pathname.indexOf("select-campus.html") == -1) {
		
		currentCampus = localStorage.getItem("current-campus");
		console.log('[App Loaded]Current campus set to: ' + currentCampus);
		
		if (currentCampus == null) {
			window.location = "select-campus.html";
		}
	}
	
	console.log("The current campus is: " + currentCampus);

	// logic to handle page transitions
	$("#content").css("display", "none");

    $("#content").fadeIn(1000);
    
	$("a.transition").click(function(event){
		event.preventDefault();
		linkLocation = this.href;
		$("#content").fadeOut(50, redirectPage);		
	});
		
	function redirectPage() {
		window.location = linkLocation;
	}
	
	// TODO: set campus phone

});
