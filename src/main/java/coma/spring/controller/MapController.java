package coma.spring.controller;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@Controller
@RequestMapping("/map/")
public class MapController {
	@RequestMapping("toMap")
	public String map() {
		return "/map/map";
	}
	
	@ResponseBody
	@RequestMapping(value="food",produces="application/json;charset=UTF-8",method=RequestMethod.GET)
	public String getFood(String lng, String lat) throws Exception{
		final String APPKEY = "e156322dd35cfd9dc276f1365621ae9a";
		final String API_URL = "https://dapi.kakao.com/v2/local/search/category.json?category\\_group\\_code=FD6&radius=20000&";
		HttpHeaders headers = new HttpHeaders();
//		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
		headers.add("Authorization", "KakaoAK " + APPKEY);
		MultiValueMap<String, String> parameters = new LinkedMultiValueMap<>();
		parameters.add("x", lng);
		parameters.add("y", lat);
//		parameters.add("input_coord", "WGS84");
		
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> result = restTemplate.exchange(API_URL, HttpMethod.GET, new HttpEntity(headers), String.class);
		
		System.out.println(result.getBody());
		JsonElement element = JsonParser.parseString(result.getBody());
		// JSONArray jsonArray = (JSONArray)jsonObject.get("documents");
		JsonArray jsonArray = (JsonArray)element.getAsJsonObject().get("documents");
		JsonObject local = (JsonObject)jsonArray.get(0);
		JsonObject jsonArray1 = (JsonObject)local.get("address");
		
		Gson gson = new Gson();
		String json = gson.toJson(local);
		return json;
	}
	
//	public static String getJSONData() throws Exception{
//		
//	}
}
