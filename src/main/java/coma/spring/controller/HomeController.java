package coma.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class HomeController {

	@RequestMapping("/")
	public String home() {

		// 와우와우와우와우~~~~~~~ 저는 오늘 차돌순두부를 먹을겁니다 지은씨가추천한 차돌순두부~~~~
		return "home";
	}
	
}
