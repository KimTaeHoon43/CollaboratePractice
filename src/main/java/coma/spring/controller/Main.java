package coma.spring.controller;

import java.net.URI;
import java.net.URISyntaxException;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

public class Main {
    private static final String HOST = "https://dapi.kakao.com";
    public static void main(String[] args) throws RestClientException, URISyntaxException {
    	paymentReady();
    }
    private static void paymentReady() throws RestClientException, URISyntaxException {
        RestTemplate restTemplate = new RestTemplate();
    
        MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
        params.add("x", "37.566826");
        params.add("y", "126.9786567");
        params.add("category_group_code", "FD6");
        params.add("radius", "20000");
        	
	    HttpHeaders headers = new HttpHeaders();
	    headers.add("Authorization", "KakaoAK " + "e156322dd35cfd9dc276f1365621ae9a");
	    headers.add("Accept",MediaType.APPLICATION_JSON_UTF8_VALUE);
	    headers.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charser=UTF-8");
	    
        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
        String respBody = restTemplate.postForObject(new URI(HOST + "/v2/local/search/category.json"), request, String.class);
        System.out.println(respBody);
    }
}
