<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!Doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="X-UA-Compatible" content="IE=7,9,10">
<title>Weather App</title>
<script src="<c:url value="/resources/js/jquery-1.8.2.js" />"></script>
<script src="<c:url value="/resources/js/jquery.validate.min.js" />"></script>
<script type="text/javascript">

$(document).ready(function () {

    $('#weather-check').validate({ 
        rules: {
        	city: {
                required: true,
                maxlength: 100
            }
        }
    });

});

$(function() {
    $('#weather-check').submit(function(event) {  
        event.preventDefault();   
        var arrCity = $("#city").val().split(",").map(function(item) {
        	  return item.trim();
        	});
        var citynames = {
                cityname: arrCity,               
            }
            $.ajax({
                type: 'POST',
                url: '/WeatherApp/weatherCheck',
                contentType: 'application/json',
                success: function(res){
                	$('#modal').empty();
                	$.each(res, function(id, results){
                		if(results !== null){
                			console.log(JSON.stringify(results.display_location.full) +""+ results.temperature_string);
                			$('#modal').append(' <div class="col s12 m7"><div class="card horizontal"><div class="card-image"><img src="'+results.icon_url+'" alt="" ></div> <div class="card-stacked"><div class="card-content"><p>'+ "&nbsp  <b>Country</b> :"+JSON.stringify(results.display_location.full)+"<b> Temperature </b>: "+ results.temperature_string+'</p></div><div class="card-action"></div></div></div></div>&nbsp');
                		}

                	    
                	   });
                   
                        
                    
                },
                data: JSON.stringify(citynames),
                statusCode: {
                    500: function(res){
                    	$('#modal').append('<div class="cities">'+ "City Information Not Found"+'</>');
                    }
                }
             });
        return false;
     });
 });
$body = $("body");

$(document).on({
    ajaxStart: function() { $body.addClass("loading");    },
     ajaxStop: function() { $body.removeClass("loading"); }    
});
	</script>

<style type="text/css">
.modal {
    display:    none;
    position:   fixed;
    z-index:    1000;
    top:        0;
    left:       0;
    height:     100%;
    width:      100%;
    background: rgba( 255, 255, 255, .8 ) 
                url('http://i.stack.imgur.com/FhHRx.gif') 
                50% 50% 
                no-repeat;
}

/* When the body has the loading class, we turn
   the scrollbar off with overflow:hidden */
body.loading {
    overflow: hidden;   
}

/* Anytime the body has the loading class, our
   modal element will be visible */
body.loading .modal {
    display: block;
}
.card {
	box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
	transition: 0.3s;
	width: 40%;
}

.card:hover {
	box-shadow: 0 8px 16px 0 rgba(0, 0, 0, 0.2);
}

.container {
	padding: 2px 16px;
}
.card.horizontal {
        display: -webkit-flex;
        display: -ms-flexbox;
        display: flex;
    }
</style>
</head>
<body>
	<h1 style="text-align: center; color: darkblue">Weather Check</h1>

	<%-- <h3>Message : ${message}</h3>
<h3>Counter : ${counter}</h3> --%>

	<div align="center">
		<form id="weather-check">
			<input type="text" class="weather" placeholder="enter city name(s)"
				maxlength="100" style="text-align: center; width: 200px;"
				name="city" id="city" /> <br> <br>
			<input type="submit" value="submit" id="cityname" name="cityname" />
		</form>
	</div>

	<div id="modal" ></div>
	
	
  
 <!-- <div class="col s12 m7">
    <div class="card horizontal">
      <div class="card-image">
        <img src="https://lorempixel.com/100/190/nature/6" style="height:100%">
      </div>
      <div class="card-stacked">
        <div class="card-content">
          <p>I am a very simple card. I am good at containing small bits of information.</p>
        </div>
        <div class="card-action">
          <a href="#">This is a link</a>
        </div>
      </div>
    </div>
  </div> -->




</body>
</html>