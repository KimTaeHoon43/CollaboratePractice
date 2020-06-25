package coma.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class HomeController {

	@RequestMapping("/")
	public String home() {

		// 수정하였습니다 과연 UTF-8 가능할까요??
	//으아으아으ㅏ으ㅏ
		return "home";
	}
	
}
