package coma.spring.controller;

import java.net.URI;
import java.net.URISyntaxException;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@Controller
@RequestMapping("/map/")
public class MapController {
	
	private static final String HOST = "https://dapi.kakao.com";
	
	@RequestMapping("toMap")
	public String map() {
		return "/map/map";
	}
	
	@ResponseBody
	@RequestMapping(value="food",produces="application/json;charset=utf8",method=RequestMethod.GET)
	public String getFood(String lng, String lat) throws RestClientException, URISyntaxException{
//		final String APPKEY = "e156322dd35cfd9dc276f1365621ae9a";
//		final String API_URL = "https://dapi.kakao.com/v2/local/search/category.json?category\\_group\\_code=FD6&radius=20000";
//		HttpHeaders headers = new HttpHeaders();
//		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
//		headers.add("Authorization", "KakaoAK " + APPKEY);
////		headers.set("Content-Type", "application/json");
//		Map<String, String> parameters = new HashMap<>();
//		parameters.put("x", lng);
//		parameters.put("y", lat);
////		parameters.add("input_coord", "WGS84");
//		
//		RestTemplate restTemplate = new RestTemplate();
//		ResponseEntity<String> result = restTemplate.exchange(API_URL, HttpMethod.GET, new HttpEntity(headers), String.class);
//		restTemplate.setErrorHandler(new MyErrorHandler());
//		
        RestTemplate restTemplate = new RestTemplate();
        
        MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
        params.add("x", lng);
        params.add("y", lat);
        params.add("category_group_code", "FD6");
        params.add("radius", "20000");
        	
	    HttpHeaders headers = new HttpHeaders();
	    headers.add("Authorization", "KakaoAK " + "e156322dd35cfd9dc276f1365621ae9a");
	    headers.add("Accept",MediaType.APPLICATION_JSON_UTF8_VALUE);
	    headers.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charser=UTF-8");
	    
        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
        String respBody = restTemplate.postForObject(new URI(HOST + "/v2/local/search/category.json"), request, String.class);
        System.out.println(respBody);
//		
//		System.out.println(result.getBody());
//		JsonElement element = JsonParser.parseString(result.getBody());
//		// JSONArray jsonArray = (JSONArray)jsonObject.get("documents");
//		JsonArray jsonArray = (JsonArray)element.getAsJsonObject().get("documents");
//		JsonObject local = (JsonObject)jsonArray.get(0);
//		JsonObject jsonArray1 = (JsonObject)local.get("address");
//		
//		Gson gson = new Gson();
//		String json = gson.toJson(local);
		return respBody;
	}
	
//	public static String getJSONData() throws Exception{
//		
//	}
}
