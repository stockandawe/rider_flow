var transitMap = {
  mapOptions: {
    zoom: 14,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  },
  map: null,
  user_pos: null,
  bus_markers: [],
  stop_markers: [],
  iw: new google.maps.InfoWindow(),
  activeIntervals: [],
  currentRoute: null,
  activeLine: null
};

var example_array= ['#890b0b', '#17890b', '#0b4f89', '#ffae00'];
var color;
function insertRoutes(el) {
  var line_names = ["2","8x","KT","J"];
  

  $.each(example_array, function(index, value) {
    var number = line_names[index];
    var element = $('<li id='+ index +'><p>'+ number +'</p></li>');
    element.css('background-color', value);
    element.css('cursor','pointer');
    element.addClass("line_button");
    element.click(function(e){
      console.log('showing line ' + (index+1));
      transitMap.showLine(index+1);
    });
    el.append(element);
  });
}

function initializeUI() {
  var rightpanel = $('<div id="riderStream_rightpanel"></div>');
  var rightpanel_collapsearrow = $('<div id="rightpanel_collapsearrow" class="close_arrow"></div>');
  var riderStream_rightpanel_therealdealbrotha = $('<div id="riderStream_rightpanel_therealdealbrotha"><h4>Choose your route:</h4><ul id="listofroutes"></ul></div>');
  $('#riderStream_logo').css('background-position', '-12px 22px');
  rightpanel.append(rightpanel_collapsearrow);
  rightpanel.append(riderStream_rightpanel_therealdealbrotha);
  $('#riderStream_logo').animate({
    'opacity': '1',
  }, {
    duration: 750,
    start: function() {
    },
    complete: function() {
      $(this).animate({
        'height': '90%',
        'top': '40px',
        'right': '0',
        'width': '15%'
      },{
        easing: 'easeInOutBack',
        duration: 750,
        start: function() {
        },
        complete: function() {
          $(this).append(rightpanel);
          insertRoutes($('#listofroutes'));
          rightpanel.animate({
            'opacity': '1'
          },{
            duration: 200,
            complete: function() {
              $('.close_arrow').live('click',function() {
                $(this).removeClass('close_arrow');
                $('#riderStream_logo').css('background-position', '-12px 22px');
                $(this).addClass('open_arrow');
                $('#riderStream_logo').animate({'right': '-13%'});
              });
              $('.open_arrow').live('click',function() {
                $(this).removeClass('open_arrow');
                $(this).addClass('close_arrow');
                $('#riderStream_logo').animate({'right': '0%'});
              });
            }
          })
        }
      })
    }
  })
$('#listofroutes .line_button').live('click',function(){
  $('#listofroutes .line_button').removeClass('active');
  $(this).addClass('active');
  color = $(this).attr('id');
});
}

$(document).ready(function () {
 

  transitMap.initialize = function() {
    $('#map').height($('.content.container-fluid').height());

    transitMap.map = new google.maps.Map(document.getElementById("map"), transitMap.mapOptions);

    // Try HTML5 geolocation
    if(navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        transitMap.user_pos = position;

        var pos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);

        var image = 'http://code.google.com/apis/maps/documentation/javascript/examples/images/beachflag.png';
        var beachMarker = new google.maps.Marker({
          position: pos,
          map: transitMap.map,
          icon: image
        });

        //Setting map center
        transitMap.map.setCenter(pos);
      }, function() {
        transitMap.handleNoGeolocation(true);
      });
    } else {
      transitMap.handleNoGeolocation(false); // Browser doesn't support Geolocation
    }

    google.maps.event.addListenerOnce(transitMap.map, 'tilesloaded', function(){
      initializeUI();
    });

    transitMap.setIntervals();
  };

  transitMap.handleNoGeolocation = function(errorFlag) {
    if (errorFlag) {
      var content = 'Error: The Geolocation service failed.';
    } else {
      var content = 'Error: Your browser doesn\'t support geolocation.';
    }

    var options = {
      map: map,
      position: new google.maps.LatLng(60, 105),
      content: content
    };

    var infowindow = new google.maps.InfoWindow(options);
    map.setCenter(options.position);
  };

  transitMap.showInfoWindow = function(i) {
    return function(){
      transitMap.iw.setContent(transitMap.getIWContent(transitMap.retailers[i]));
      transitMap.iw.setPosition(transitMap.markers[i].getPosition());
      transitMap.iw.open(transitMap.map);
    }
  };

  transitMap.getIWContent = function(dude) {
    var content = '<table style="border:0"><tr><td style="border:0;">';
    content += '<img class="placeIcon" src="' + dude.img_src + '" style="width: 50px"></td>';
    content += '<td style="border:0;"><strong>' + dude.name + '</strong>';
    content += '<p>' + dude.description + '</p>';
    content += '</td></tr></table>';
    return content;
  }

  google.maps.event.addDomListener(window, 'load', transitMap.initialize);

  transitMap.clearOverlays = function(array){
    for (var i = 0; i < array.length; i++)
      array[i].setMap(null);
    array = [];
  }

  // CCHAO
  transitMap.drawRoute = function(route){
    if(transitMap.currentRoute)
      transitMap.currentRoute.setMap(null);
    else
      transitMap.currentRoute = new google.maps.Polyline({ path: [], strokeColor: '#FF0000' });

    var routes = $.parseJSON(route);
    var arr = [];

    $.each(routes, function(i, item) {
      arr.push(new google.maps.LatLng(routes[i][0], routes[i][1]));
    });

    transitMap.currentRoute.setPath(arr);
    transitMap.currentRoute.strokeColor = example_array[color];
    transitMap.currentRoute.setOptions({ map: transitMap.map });

  };

  transitMap.drawStops = function(stops){
    // Cleaning previous data
    transitMap.clearOverlays(transitMap.stop_markers);

    $.each(stops, function(i, item){
      var image = 'stop_yellow.png';

      if(stops[i].riders < 20)
        image = 'stop_green.png';
      else if(stops[i].riders > 40)
        image = 'stop_red.png';

      transitMap.stop_markers.push(
        new google.maps.Marker({
          position: new google.maps.LatLng(stops[i].lat,stops[i].long),
          map: transitMap.map,
          icon: image
        })
      );
    });
  };

  transitMap.drawBuses = function(buses){
    // Cleaning previous data
    transitMap.clearOverlays(transitMap.bus_markers);

    $.each(buses, function(i, item){
      var image = 'bus_yellow.png';

      if(buses[i].riders < 20)
        image = 'bus_green.png';
      else if(buses[i].riders > 40)
        image = 'bus_red.png';

      transitMap.bus_markers.push(
        new google.maps.Marker({
          position: new google.maps.LatLng(buses[i].lat,buses[i].long),
          map: transitMap.map,
          icon: image
        })
      );
    });
  };

  transitMap.showLine = function(lineid){
    transitMap.activeLine = lineid;
    // Loading data
    $.getJSON('api/lines/'+transitMap.activeLine, function(data) {
      transitMap.drawRoute(data.route);
    });
    $.getJSON('api/lines/'+transitMap.activeLine+'/stops', function(data) {
      transitMap.drawStops(data);
    });
    $.getJSON('api/lines/'+transitMap.activeLine+'/buses', function(data) {
      transitMap.drawBuses(data);
    });
  };

  transitMap.setIntervals = function(){
    // Setting intervals
    window.setInterval(function(){
      if(transitMap.activeLine){
        console.log('updating stops...');
        $.getJSON('api/lines/'+transitMap.activeLine+'/stops', function(data) {
          transitMap.drawStops(data);
        });
      }
    }, 10000);

    window.setInterval(function(){
      if(transitMap.activeLine){
        console.log('updating buses...');
        $.getJSON('api/lines/'+transitMap.activeLine+'/buses', function(data) {
          transitMap.drawBuses(data);
        });
      }
    }, 10000);
  };

  
});
