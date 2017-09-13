<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!Doctype html>
<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta http-equiv="X-UA-Compatible" content="IE=7,9,10" >
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
                	$('#results').empty();
                	$.each(res, function(id, results){
                		if(results !== null){
                			console.log(JSON.stringify(results.display_location.full) +""+ results.temperature_string);
                			$('#results').append('<div class="cities">'+ "Country :"+JSON.stringify(results.display_location.full) +"- Temperature : "+ results.temperature_string+'</>');
                		}
                		
                		
                		 //$('#results').html(results.response.results[0].name);
                		 //$('#results').append('<div class="cities">'+results.response.results[0].name+'</>');
                	    
                	   });
                   
                        
                    
                },
                data: JSON.stringify(citynames),
                statusCode: {
                    404: function(){
                        
                    }
                }
             });
        return false;
     });
 });
	</script>
</head>
<body>
<h1 style="text-align: center; color: darkblue">Weather Check</h1>
 
<%-- <h3>Message : ${message}</h3>
<h3>Counter : ${counter}</h3> --%>	

<div align="center">
    <form id="weather-check" >
    <input type="text" class="weather" placeholder="enter city name(s)" maxlength="100" style="text-align: center;width: 200px;" name="city" id="city" />
   <br> <br><input type="submit" value="submit" id="cityname" name="cityname"/>  
</form>
 </div>
 
 <div id="results" class = "card-green" id="green-column-2">
 
 </div>
 
 
 
 
</body>
</html>