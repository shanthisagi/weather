package com.wunderground.service;

import java.net.URISyntaxException;

import org.apache.http.HttpException;
import org.json.simple.JSONObject;

public interface HTTPResponse {	
	 
	public JSONObject connect(String cityName, String countryName, String stateCode) throws URISyntaxException, HttpException;
	
	
}
