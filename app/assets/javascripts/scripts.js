function insertRoutes(element) {
  var example_array= [1, 2, 3, 4, 5];
  $.each(example_array, function(index, value) { 
    element.append($('<li></li>')) ;
  });
}

function initializeUI() {
  var rightpanel = $('<div id="riderStream_rightpanel"></div>');
  var rightpanel_collapsearrow = $('<div id="rightpanel_collapsearrow" class="close_arrow"></div>');
  var riderStream_rightpanel_therealdealbrotha = $('<div id="riderStream_rightpanel_therealdealbrotha"><h4>Choose your route:</h4><div id="listofroutes"></div></div>');
  insertRoutes($('#listofroutes'));
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
          //$(this).css('background-image', 'none');
        },
        complete: function() {
          $(this).append(rightpanel);
          rightpanel.animate({ 
            'opacity': '1'
          },{
            duration: 200,
            complete: function() {                              
              $('.close_arrow').live('click',function() {
                $(this).removeClass('close_arrow');
                $(this).addClass('open_arrow');
                $('#riderStream_logo').removeClass('showlogo');
                $('#riderStream_logo').animate({'right': '-13%'});

              });
              $('.open_arrow').live('click',function() {
                $(this).removeClass('open_arrow');
                $(this).addClass('close_arrow');
                $('#riderStream_logo').addClass('showlogo');
                $('#riderStream_logo').animate({'right': '0%'});
              });
            }
          })
        }
      })
}
})

}

$(document).ready(function () {
  var transitMap = {
    mapOptions: {
      zoom: 14,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    },
    map: null,
    user_pos: null,
    retailers: [],
    markers: [],
    iw: new google.maps.InfoWindow()
  };

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


    drawing();
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
  

  // do something only the first time the map is loaded



  // CCHAO


  test = new google.maps.Polyline({
    path: [], strokeColor: '#FF0000'
  });

  function drawing(){
    
    $.getJSON('api/lines/1', function(data) {
      var routes = $.parseJSON(data.route);

      var arr = [];

      $.each(routes, function(i, item) {
        arr.push(new google.maps.LatLng(routes[i][0], routes[i][1]));
      });

      test.setPath(arr);
      test.setOptions({ map: transitMap.map });
    });
  }



});