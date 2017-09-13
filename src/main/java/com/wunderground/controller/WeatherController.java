package com.wunderground.controller;

import java.net.URISyntaxException;
import java.text.ParseException;

import javax.validation.Valid;

import org.apache.http.HttpException;
import org.json.simple.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.wunderground.service.Impl.HTTPResponse;
import com.wunderground.vo.WeatherVo;

@Controller
public class WeatherController {
	

	@RequestMapping(value = "/weatherCheck", method = RequestMethod.POST)
	@ResponseBody
	public JSONArray getWeatherCheck(@Valid @RequestBody WeatherVo weatherVo) throws URISyntaxException, HttpException, ParseException{		
		HTTPResponse httpResponse = new HTTPResponse();
		JSONArray jsonArray = httpResponse.getWeatherInfo(weatherVo.getCity());		
		return jsonArray;
		
	}
	
	

}
