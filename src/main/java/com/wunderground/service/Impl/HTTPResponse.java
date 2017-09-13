package com.wunderground.service.Impl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URISyntaxException;
import java.text.ParseException;
import java.util.List;

import org.apache.http.HttpException;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.CoreConnectionPNames;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.wunderground.util.Constants;

public class HTTPResponse implements  com.wunderground.service.HTTPResponse  {

	private HttpGet get;
	private final Logger logger = LoggerFactory.getLogger(HTTPResponse.class);
	private JSONObject jsonObject;
	
	public JSONArray getWeatherInfo(List<String> cityNames) throws ParseException, URISyntaxException, HttpException{
		JSONArray arr = new JSONArray();
		JSONObject json = new JSONObject();
		JSONObject jsonWeather = new JSONObject();
		for(int i = 0 ; i < cityNames.size() ; i++) {
			json=connect(cityNames.get(i), null, null);
			JSONArray jsonArray = (JSONArray)json.get("results");
			if(json != null && jsonArray == null){				
				 arr.add(json.get("current_observation"));
			}
			else{
			 for (int j = 0, length = jsonArray.size(); j < length; j++)
			    {
			      Object obj = jsonArray.get(j);
			      Object obj1 = null;
			      if(j+1 < jsonArray.size()){
			      obj1 = jsonArray.get(j+1);			      
			      }else {
			    	  obj1 = jsonArray.get(j-1);
			      }
			      JSONObject jsonObj = (JSONObject) obj;
			      JSONObject jsonObj1 = (JSONObject) obj1;
			      String city = (String) jsonObj.get("city");
			      String countryName = (String) jsonObj.get("country_name");
			      String duplicateCountryName = (String) jsonObj1.get("country_name");
			      String stateCode = (String) jsonObj.get("state");
			      if(countryName.equals(duplicateCountryName)){
			    	  String conCountryName = countryName.replaceAll(" ", "_").toLowerCase();
			    	  jsonWeather = connect(city, conCountryName, stateCode);
			      }else{
			    	  String conCountryName = countryName.replaceAll(" ", "_").toLowerCase();
			    	  jsonWeather = connect(city, conCountryName, null);
			      }
		          arr.add(jsonWeather);
			      
			    }
			}
		 }
		 
		 
		
		
		return arr;
	}
	
	@Override
	public JSONObject connect(String cityName, String countryName, String stateCode) throws URISyntaxException, HttpException {
	 DefaultHttpClient httpClient = new DefaultHttpClient();
		httpClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 20000);
		logger.debug("cityName :" + cityName);
		if(stateCode != null){
			get = new HttpGet(Constants.WEATHER_CHECK_URL + cityName +"_"+stateCode+"_"+countryName+".json");
		}else{
		     get = new HttpGet(Constants.WEATHER_CHECK_URL + cityName +"_"+countryName+".json");}
		logger.debug("url :" + get);
		HttpResponse res;
		try {
			res = httpClient.execute(get);
			if (res.getStatusLine().getStatusCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + res.getStatusLine().getStatusCode());
			} else {
				BufferedReader br = null;
				InputStreamReader inputStream = null;
				try {
					inputStream = new InputStreamReader(res.getEntity().getContent());
					br = new BufferedReader(inputStream);

					StringBuilder content = new StringBuilder();
					String line;
					while (null != (line = br.readLine())) {
						content.append(line);
					}

					Object obj = JSONValue.parse(content.toString());					
					jsonObject = (JSONObject) obj;					
					if(stateCode != null || countryName != null){
						Object obj1 = jsonObject.get("current_observation");
						jsonObject = (JSONObject) obj1;		
					}else{
						Object obj1 = jsonObject.get("current_observation");
						if(obj1 == null){
						obj1 = jsonObject.get("response");
						jsonObject = (JSONObject) obj1;
						}
					}
					
								
					
					
				} finally {
					if (br != null){
					br.close();
					inputStream.close();
					}

				}
			}

		} catch (IOException io) {
			res = null;
		}

		return jsonObject;
	}
	

}
